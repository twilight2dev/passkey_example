-- CreateTable
CREATE TABLE "User" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "username" TEXT NOT NULL DEFAULT '',
    "registered" BOOLEAN NOT NULL DEFAULT false
);

-- CreateTable
CREATE TABLE "Credentials" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "user_id" TEXT NOT NULL,
    "credential_id" TEXT NOT NULL DEFAULT '',
    "public_key" TEXT NOT NULL,
    "counter" INTEGER NOT NULL,
    "transports" TEXT,
    CONSTRAINT "Credentials_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateIndex
CREATE UNIQUE INDEX "User_username_key" ON "User"("username");

-- CreateIndex
CREATE UNIQUE INDEX "Credentials_credential_id_key" ON "Credentials"("credential_id");
