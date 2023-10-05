import { v4 as uuidv4 } from "uuid";
import jwt from "jsonwebtoken";
import { cachingType, getPgClient, postgresQuery } from "../../services/dbengine";
import { internalServerError } from "../../standard";
import { getCurrentDate } from "../../common/functions";
import { UserJwToken, UserToken, UserTokenSerializer } from "../../services/interfaces/userJwtInterface";
import * as crypto from 'crypto'

export async function userLoginOrSignup(req: any, res: any) {
    try {
        const mobile = req?.body?.mobile !== undefined ? req?.body?.mobile : null;
        const otp = req?.body?.otp !== undefined ? req?.body?.otp : null;
        if (mobile === null) {
            return res.status(422).send({
                "status": false,
                "message": "Unprocessable entity",
                "data": {}
            });
        }
        const userExistQuery = `SELECT COUNT(user_id) FROM users WHERE mobile = $1`;
        const userExistQueryResult = await postgresQuery(userExistQuery, [mobile], cachingType.NoCache);
        const userExistValue = userExistQueryResult?.queryResponse[0]?.count === '0';
        if (!otp) {
            await sendOtp(mobile, userExistValue ? false : true, res);
        } else {
            await verifyOtp(mobile, userExistValue ? false : true, otp, res);
        }
    } catch (e) {
        return res.status(500).send(internalServerError);
    }
}


async function sendOtp(mobile: any, exist: boolean, res: any) {
    try {
        const otp = Math.floor(100000 + Math.random() * 9000);
        const minutesToAdd = 1;
        const currentDate = getCurrentDate();
        const futureDate = new Date(
            currentDate.getTime() + minutesToAdd * 60000
        ).toISOString();
        const expirationTime = futureDate;
        if (exist) {
            const selectNonExpiredOtpFromUserTable = `
            SELECT COUNT(otp_created_at)
            FROM users
            WHERE mobile = $1
            AND EXTRACT(EPOCH FROM NOW() - otp_created_at) < 30`;
            const selectNonExpiredOtpFromUserTableResult = await postgresQuery(selectNonExpiredOtpFromUserTable, [mobile], cachingType.NoCache);
            if (selectNonExpiredOtpFromUserTableResult?.queryResponse[0]?.count === '0') {
                const updateUsersQuery = `UPDATE users SET otp= $1, expiration_time = $2, otp_verified= $3, otp_created_at= $4 WHERE mobile = $5`;
                const updateUsersQueryrResult = await postgresQuery(updateUsersQuery, [otp, expirationTime, false, currentDate, mobile]);
                if (updateUsersQueryrResult?.queryResponse) {
                    return res.status(200).send({
                        "status": true,
                        "message": "Otp sent!",
                        "data": { "otp": otp }
                    });
                } else {
                    return res.status(500).send({
                        "status": false,
                        "message": "Internal server error. Unable to send otp",
                        "data": {}
                    });
                }
            } else {
                return res.status(200).send({
                    "status": false,
                    "message": "Otp already sent. Try again after 30 seconds",
                    "data": {}
                });
            }
        } else {
            const selectNonExpiredTempUser = `SELECT COUNT(otp_created_at)
            FROM temp_users
            WHERE mobile = $1
            AND EXTRACT(EPOCH FROM NOW() - otp_created_at) < 30`;
            const selectNonExpiredTempUserResult = await postgresQuery(selectNonExpiredTempUser, [mobile], cachingType.NoCache);
            if (selectNonExpiredTempUserResult?.queryResponse[0]?.count === '0') {
                const tempUserId = uuidv4();
                const insertIntoTempUsers = `INSERT INTO temp_users (user_id, mobile, otp, expiration_time, otp_verified, otp_created_at ) VALUES ($1, $2, $3, $4, $5, $6)`;
                const insertIntoTempUsersQueryResult = await postgresQuery(insertIntoTempUsers, [tempUserId, mobile, otp, expirationTime, false, currentDate], cachingType.NoCache);
                if (insertIntoTempUsersQueryResult?.queryResponse) {
                    return res.status(200).send({
                        "status": true,
                        "message": "Otp sent!",
                        "data": { "otp": otp }
                    });
                } else {
                    return res.status(500).send({
                        "status": false,
                        "message": "Internal server error. Unable to send otp",
                        "data": {}
                    });
                }
            } else {
                return res.status(200).send({
                    "status": false,
                    "message": "Otp already sent. Try again after 30 seconds",
                    "data": {}
                });
            }
        }
    } catch (e) {
        return res.status(500).send(internalServerError);
    }
}

function encrypt(data: string, encryptionKey: Buffer): { iv: Buffer, encryptedData: string } {
    const iv = crypto.randomBytes(16); 
    const cipher = crypto.createCipheriv('aes-256-cbc', encryptionKey, iv);
    let encrypted = cipher.update(data, 'utf8', 'hex');
    encrypted += cipher.final('hex');
    return { iv, encryptedData: encrypted };
  }

 export function decrypt(encryptedData: string, encryptionKey: Buffer, iv: Buffer): string {
    const decipher = crypto.createDecipheriv('aes-256-cbc', encryptionKey, iv);
    let decrypted = decipher.update(encryptedData, 'hex', 'utf8');
    decrypted += decipher.final('utf8');
    return decrypted;
  }

async function verifyOtp(mobile: any, exist: any, otp: any, res: any) {
    try {
        if (exist) {
            const selectUserDataQuery = `
           SELECT 
           user_id, 
           name, 
           mobile, 
           latitude, 
           longitude, 
           otp, 
           expiration_time, 
           otp_verified, 
           otp_created_at
           FROM
           users
           WHERE
           mobile = $1`;
            const selectQueryResult = await postgresQuery(selectUserDataQuery, [mobile], cachingType.NoCache);
            if (selectQueryResult?.queryResponse) {
                const data = selectQueryResult?.queryResponse[0];
                const userId = data?.user_id;
                const name = data?.name;
                const mobile = data?.mobile;
                const latitude = data?.latitude;
                const longitude = data?.longitude;
                const otpFromDb = data?.otp?.toString();
                const expiry = data?.expiration_time;
                const otpVerified = data?.otp_verified;
                const otpFromRequest = otp?.toString();
                const currentDate = getCurrentDate();
                if (otpFromDb === otpFromRequest) {
                    if (otpVerified === false) {
                        if (expiry > currentDate) {
                            const updateOtpStatusQuery = `UPDATE users SET otp_verified = $1 WHERE user_id = $2`;
                            const updateOtpStatusQueryResult = await postgresQuery(updateOtpStatusQuery, [true, userId], cachingType.NoCache);
                            if (updateOtpStatusQueryResult?.queryResponse) {
                                // const encryptionKey = crypto.randomBytes(32);
                                // const key2 = encryptionKey.toString('hex');
                                // return res.status(200).send(key)
                                const ivMixKey : string = '4e72f609939f3896a48a09064c45c37b57ddfe7c1b133dacafa5aa968f2e8cba1d09b1c011228b51a8028aca6d39bc9d779a069f97c9fb4379c222e0413fcbc6';
                                const key: string = '8d773d930d25dca67c3a875e4efa53257aa697a5fb77ba2dfaedfcc367c7a83b';
                                const keyBuffer = Buffer.from(key, 'hex')
                                const toToken : UserToken = {
                                    id: userId,
                                    mobile: mobile,
                                    name: name,
                                    latitude: latitude,
                                    longitude: longitude,
                                    iat: Date.now(),
                                    exp: Date.now() + 3600 * 1000,
                                };
                                const json = UserTokenSerializer.toJSON.call(toToken);
                                const jsonString = json.toString()
                                const token = encrypt(jsonString, keyBuffer);
                                const iv = token.iv;
                                const ivHex = iv.toString('hex');
                                const mixedIv = mixIV(ivHex, ivMixKey)
                                return res.status(200).send({
                                    "status": true,
                                    "message": "Authenticated successfully",
                                    "data": {
                                        "token": mixedIv + '.' +  token.encryptedData,
                                    }
                                });
                            } else {
                                return res.status(499).send({
                                    "status": false,
                                    "message": "Something wen't wrong",
                                    "data": {}
                                });
                            }
                        } else {
                            return res.status(200).send({
                                "status": false,
                                "message": "Otp expired",
                                "data": {}
                            });
                        }
                    } else {
                        return res.status(200).send({
                            "status": false,
                            "message": "Otp already used. request new one",
                            "data": {}
                        });
                    }
                } else {
                    return res.status(200).send({
                        "status": false,
                        "message": "Invalid otp",
                        "data": {}
                    });

                }

            } else {
                return res.status(404).send({
                    "status": false,
                    "message": "User not found",
                    "data": {}
                });
            }
        } else {
            const selectTempUsersData = `
            SELECT 
            user_id, 
            otp, 
            expiration_time, 
            otp_verified, 
            otp_created_at
            FROM 
            temp_users 
            WHERE 
            mobile = $1
            AND 
            otp_created_at = (
            SELECT 
            MAX(otp_created_at)
            FROM 
            temp_users
            WHERE 
            mobile = $1
            )`;
            const selectAccountQueryResult = await postgresQuery(selectTempUsersData, [mobile], cachingType.NoCache);
            if (selectAccountQueryResult?.queryResponse[0]) {
                const otpFromDb = selectAccountQueryResult?.queryResponse[0]?.otp?.toString();
                const otpFromRequest = otp?.toString();
                const expirationTime = new Date(selectAccountQueryResult?.queryResponse[0]?.expiration_time);
                const currentDate = getCurrentDate();
                const otpVerified = selectAccountQueryResult?.queryResponse[0]?.otp_verified;
                if (otpFromDb === otpFromRequest) {
                    if (otpVerified === false) {
                        if (expirationTime > currentDate) {
                            const userId = selectAccountQueryResult?.queryResponse[0]?.user_id;
                            const updateTemUsers = `UPDATE temp_users SET otp_verified = $1 WHERE user_id = $2 AND otp = $3`;
                            const updateTempUsersQueryResult = await postgresQuery(updateTemUsers, [true, userId, otp]);
                            if (updateTempUsersQueryResult?.queryResponse) {
                                    const tableId = userId.replace(/-/g, "_");
                                    getPgClient((err: any, client: any, done: any, response: any) => {
                                        const start = Date.now();
                                        const shouldAbort = (err: any) => {
                                            if (err) {
                                                const duration = Date.now() - start;
                                                console.error(
                                                    `Time is : ${duration}, Error in transaction`,
                                                    err.stack
                                                );
                                                client.query("ROLLBACK", (err: any) => {
                                                    if (err) {
                                                        const duration = Date.now() - start;
                                                        console.error(
                                                            `Time is : ${duration}, Error rolling back client`,
                                                            err.stack
                                                        );
                                                    }
                                                    done();
                                                });
                                                res.status(200).json({
                                                    status: false,
                                                    message: "Cannot create user. Please contact support",
                                                    data: [],
                                                });
                                            }
                                            return !!err;
                                        };

                                        client.query('BEGIN', [], (err: any, response: any) => {
                                            if (shouldAbort(err)) return;
                                            console.log('🚀BLOC 1');
                                            
                                            const insertNewUserQuery = `INSERT INTO users(user_id, mobile, name) VALUES ($1, $2, $3)`;
                                            client.query(insertNewUserQuery, [userId, mobile, 'Irshad'], (err:any, response:any)=>{
                                                if (shouldAbort(err)) return;
                                                console.log('🚀BLOC 2');

                                            const createUserOrderTable = ` CREATE TABLE usr_${tableId}_orders(
                                                    id serial PRIMARY KEY,
                                                    order_id uuid UNIQUE NOT NULL,
                                                    status order_status,
                                                    total_amount integer,
                                                    total_qty integer,
                                                    area_admin_id uuid,
                                                    merchant_id uuid,
                                                    FOREIGN KEY (area_admin_id) REFERENCES area_admins (area_admin_id)
                                                )`;
                                            client.query(createUserOrderTable, [], (err: any, response: any) => {
                                                if (shouldAbort(err)) return;
                                                console.log('🚀BLOC 3');
                                                const createUserOrderItemsQuery = `CREATE TABLE usr_${tableId}_order_items(
                                                    id serial PRIMARY KEY,
                                                    order_item_id uuid UNIQUE NOT NULL,
                                                    order_id uuid NOT NULL,
                                                    product_id uuid NOT NULL,
                                                    qty integer NOT NULL,
                                                    area_admin_id uuid,
                                                    merchant_id uuid,
                                                    FOREIGN KEY (order_id) REFERENCES usr_${tableId}_orders (order_id),
                                                    FOREIGN KEY (area_admin_id) REFERENCES area_admins (area_admin_id)
                                                )`;

                                                client.query(createUserOrderItemsQuery, [], (err: any, response: any) => {
                                                    if (shouldAbort(err)) return;
                                                    console.log('🚀BLOC 4');

                                                    const createUserCartTableQuery = `CREATE TABLE usr_${tableId}_cart(
                                                        id serial PRIMARY KEY,
                                                        cart_item_id uuid UNIQUE NOT NULL,
                                                        product_id uuid NOT NULL,
                                                        qty integer NOT NULL,
                                                        area_admin_id uuid,
                                                        merchant_id uuid,
                                                        created_at timestamp DEFAULT now(),
                                                        FOREIGN KEY (area_admin_id) REFERENCES area_admins (area_admin_id)
                                                    )`;

                                                    client.query(createUserCartTableQuery, [], (err: any, response: any) => {
                                                        if (shouldAbort(err)) return;
                                                        console.log('🚀BLOC 5');

                                                        const createUserMyItemsTableQuery = `CREATE TABLE usr_${tableId}_my_items(
                                                            id serial PRIMARY KEY,
                                                            item_id uuid UNIQUE NOT NULL,
                                                            product_id uuid NOT NULL,
                                                            area_admin_id uuid,
                                                            merchant_id uuid,
                                                            created_at timestamp DEFAULT now(),
                                                            FOREIGN KEY (area_admin_id) REFERENCES area_admins (area_admin_id)
                                                        )`;

                                                        client.query(createUserMyItemsTableQuery, [], (err: any, response: any) => {
                                                            if (shouldAbort(err)) return;
                                                            console.log('🚀BLOC 6');

                                                            const createUserAddressTableQuery = `CREATE TABLE usr_${tableId}_addresses(
                                                                id serial PRIMARY KEY,
                                                                address_id uuid UNIQUE NOT NULL,
                                                                address varchar,
                                                                is_billing boolean DEFAULT false,
                                                                is_shipping boolean DEFAULT false
                                                            )`;

                                                            client.query(createUserAddressTableQuery, [], (err: any, response: any) => {
                                                                if (shouldAbort(err)) return;
                                                                console.log('🚀BLOC 7');

                                                                const createUserLogTable = `CREATE TABLE usr_${tableId}_user_logs(
                                                                    id serial PRIMARY KEY,
                                                                    log_id uuid UNIQUE NOT NULL,
                                                                    log text,
                                                                    related_query text,
                                                                    created_at timestamp
                                                                )`;

                                                                client.query(createUserLogTable, [], (err: any, response: any) => {
                                                                    if (shouldAbort(err)) return;

                                                                    client.query('COMMIT', [], (err: any, req: any, response: any) => {
                                                                        if (err) {
                                                                            const duration = Date.now() - start
                                                                            console.error(`Time is : ${duration}, Error committing transaction`, err.stack);
                                                                            res.status(500).send(internalServerError);
                                                                        }
                                                                        done();
                                                                        console.log('🚀BLOC 18');
                                                                        const toJwt: UserJwToken = {
                                                                            id: userId,
                                                                            mobile: mobile,
                                                                        }
                                                                        const token = jwt.sign(toJwt, String(process.env.JWT_KEY), { expiresIn: '365 days' });
                                                                        return res.status(200).send({
                                                                            "status": true,
                                                                            "message": "User signup successful",
                                                                            "data": {
                                                                                "token": token
                                                                            }
                                                                        });
                                                                    });
                                                                });
                                                            });
                                                        });
                                                    });
                                                });
                                            });
                                        }); });
                                    });
                                
                            } else {
                                return res.status(499).send({
                                    "status": false,
                                    "message": "Something wen't wrong",
                                    "data": {}
                                });
                            }
                        } else {
                            return res.status(200).send({
                                "status": false,
                                "message": "Otp expired",
                                "data": {}
                            });
                        }
                    } else {
                        return res.status(200).send({
                            "status": false,
                            "message": "Otp already used. request new one",
                            "data": {}
                        });
                    }
                } else {
                    return res.status(200).send({
                        "status": false,
                        "message": "Invalid otp",
                        "data": {}
                    });
                }
            } else {
                return res.status(404).send({
                    "status": false,
                    "message": "Mobile number entry not found",
                    "data": {}
                });
            }

        }
    } catch (e) {
        return res.status(500).send(internalServerError);
    }
}

function mixIV(ivHex: string, secretKey: string): string {
    const ivBuffer = Buffer.from(ivHex, 'hex');
    const keyBuffer = Buffer.from(secretKey, 'hex');
    const mixedBuffer = Buffer.alloc(ivBuffer.length);
  
    for (let i = 0; i < ivBuffer.length; i++) {
      mixedBuffer[i] = ivBuffer[i] ^ keyBuffer[i];
    }
  
    return mixedBuffer.toString('hex');
  }
  
export  function unmixIV(mixedHex: string, secretKey: string): string {
    const mixedBuffer = Buffer.from(mixedHex, 'hex');
    const keyBuffer = Buffer.from(secretKey, 'hex');
    const unmixedBuffer = Buffer.alloc(mixedBuffer.length);
  
    for (let i = 0; i < mixedBuffer.length; i++) {
      unmixedBuffer[i] = mixedBuffer[i] ^ keyBuffer[i];
    }
  
    return unmixedBuffer.toString('hex');
  }

export async function verifyUserTokenMw(req: any, res: any){
    try {
        const userAuthData = req.authData;
         return res.status(200).send({
            "status": true,
            "message": "Authenticated successfully",
            "data": userAuthData
         })

    } catch(e){
        return res.status(403).send({
            "status": false,
            "message": "Auth failed - internal err",
            "data": {}
        })
    }
}
