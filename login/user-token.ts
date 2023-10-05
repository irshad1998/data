export interface UserToken {
    id: string;
    name?: string | null;
    mobile: string;
    latitude?: string | null;
    longitude?: string | null;
    iat: number;
    exp: number;
}

export interface JSONSerializable<T> {
    toJSON(): string;
    fromJSON(json: string): T;
}

export const UserTokenSerializer: JSONSerializable<UserToken> = {
    toJSON: function () {
        return JSON.stringify(this);
    },
    fromJSON: function (json: string) {
        return JSON.parse(json) as UserToken;
    },
};
