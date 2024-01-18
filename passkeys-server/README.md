# Passkey Relying Party Server

npx prisma migrate dev --name init
npx create-express-typescript-application passkeys-server
npm install @simplewebauthn/server uuid express-session @types/express-session @types/uuid prisma sqlite
