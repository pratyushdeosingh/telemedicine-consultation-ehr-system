const crypto = require('node:crypto');

const password = crypto.randomBytes(24).toString('base64url');
const salt = crypto.randomBytes(16);
const hash = crypto.scryptSync(password, salt, 64).toString('hex');

console.log('Save the demo password in a password manager. Do not commit or share these values:');
console.log(`Demo password: ${password}`);
console.log(`DEMO_PASSWORD_SCRYPT=${salt.toString('hex')}:${hash}`);
console.log(`SESSION_SECRET=${crypto.randomBytes(32).toString('base64url')}`);
console.log(`CRON_SECRET=${crypto.randomBytes(32).toString('base64url')}`);
