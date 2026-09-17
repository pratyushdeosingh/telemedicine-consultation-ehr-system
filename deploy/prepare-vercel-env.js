const fs = require('node:fs');
const path = require('node:path');
const crypto = require('node:crypto');

const root = path.join(__dirname, '..');
const sourcePath = path.join(root, 'backend', '.env');
const outputPath = path.join(root, '.env.vercel-import');
const required = [
  'ORACLE_USER', 'ORACLE_PASSWORD', 'ORACLE_CONNECT_STRING',
  'ORACLE_WALLET_B64', 'ORACLE_WALLET_PASSWORD',
];

if (!fs.existsSync(sourcePath)) {
  throw new Error('Run deploy/setup-oracle-local.ps1 first to create backend/.env.');
}
if (fs.existsSync(outputPath)) {
  throw new Error('An import file already exists. Import it or remove it before generating new credentials.');
}

const local = Object.fromEntries(fs.readFileSync(sourcePath, 'utf8').split(/\r?\n/)
  .map((line) => /^([A-Z][A-Z0-9_]*)=(.*)$/.exec(line))
  .filter(Boolean)
  .map((match) => {
    let value = match[2];
    if ((value.startsWith("'") && value.endsWith("'"))
      || (value.startsWith('"') && value.endsWith('"'))) value = value.slice(1, -1);
    return [match[1], value];
  }));

for (const key of required) {
  if (!local[key] || /[\r\n]/.test(local[key])) throw new Error(`${key} is missing or invalid in backend/.env.`);
}

const password = crypto.randomBytes(24).toString('base64url');
const salt = crypto.randomBytes(16);
const variables = {
  DEPLOY_TARGET: 'vercel',
  ...Object.fromEntries(required.map((key) => [key, local[key]])),
  DEMO_PASSWORD_SCRYPT: `${salt.toString('hex')}:${crypto.scryptSync(password, salt, 64).toString('hex')}`,
  SESSION_SECRET: crypto.randomBytes(32).toString('base64url'),
  CRON_SECRET: crypto.randomBytes(32).toString('base64url'),
};
const content = Object.entries(variables).map(([key, value]) => `${key}=${JSON.stringify(value)}`).join('\n') + '\n';
if (Buffer.byteLength(content) > 64 * 1024) throw new Error('Environment values exceed Vercel’s 64 KB limit.');
fs.writeFileSync(outputPath, content, { flag: 'wx', mode: 0o600 });

console.log(`Created ignored Vercel import file: ${outputPath}`);
console.log(`Demo password (save privately; do not share or commit): ${password}`);
console.log('Import this file into Vercel Production only, then delete the local import file.');
