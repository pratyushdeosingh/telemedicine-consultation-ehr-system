const dbConfig = {
    user: process.env.ORACLE_USER,
    password: process.env.ORACLE_PASSWORD,
    connectString: process.env.ORACLE_CONNECT_STRING
};

if (process.env.ORACLE_WALLET_B64) {
    dbConfig.walletContent = Buffer.from(process.env.ORACLE_WALLET_B64, 'base64').toString('utf8');
    dbConfig.walletPassword = process.env.ORACLE_WALLET_PASSWORD;
}

module.exports = dbConfig;
