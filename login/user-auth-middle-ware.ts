import { cachingType, postgresQuery } from '../../../services/dbengine';
import { decrypt, unmixIV } from '../../../logic/user/userLoginOrSignup';
import { UserToken, UserTokenSerializer } from '../../../services/interfaces/userJwtInterface';

export const userAuthMiddleWare = async (req: any, res: any, next: any)=> {
    try {
        const token : string = req?.headers['x-auth-token'];
        const split : string[] = token.split('.');
        const mixed_iv : string = split[0];
        const encrypted_data : string = split[1];
        const iv_hex_string : string = unmixIV(mixed_iv, String(process.env.IV_MIX_KEY));
        const iv_buffer : Buffer = Buffer.from(iv_hex_string, 'hex');
        const key_buffer : Buffer = Buffer.from(String(process.env.AES_KEY), 'hex');
        const decrypted = decrypt(encrypted_data, key_buffer, iv_buffer);
        const parsedData: { [key: string]: any } = JSON.parse(decrypted);
        const id = parsedData?.id !== undefined ? parsedData?.id : null;
        if(id !== null){
            const selectQuery = `SELECT user_id FROM users WHERE user_id = $1`;
            const selectQueryResult = await postgresQuery(selectQuery, [id], cachingType.NoCache);
            const idFromDb = selectQueryResult?.queryResponse[0]?.user_id;
            if(idFromDb?.toString() === id?.toString()){
                const userAuthData : UserToken = UserTokenSerializer.fromJSON(decrypted);
                req.authData = userAuthData;
                next()
            } else {
                return res.status(200).json({
                    reply: false,
                    message: 'Authentication Failed',
                    reauth: false,
                    data: {
                        "level": 3
                    },
                });
            }
        } else {
            return res.status(200).json({
                reply: false,
                message: 'Authentication Failed',
                reauth: true,
                data: {
                    "level": 2
                },
            });
        }
    } catch(e){
        res.status(200).json({
            reply: true,
            message: 'Authentication Failed',
            reauth: true,
            data:{
                "level": 1
            },
        });
    }
}
