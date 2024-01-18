import { base64ToUint8Array } from "./../utils/utils";
import { prismaClient } from "../database";
import type { AuthenticatorDevice } from "@simplewebauthn/typescript-types";

export const credentialService = {
  async createNewCredential(
    userId: string,
    credentialId: string,
    publicKey: string,
    counter: number,
    transports: string | null
  ) {
    await prismaClient.credentials.create({
      data: {
        user_id: userId,
        credential_id: credentialId,
        public_key: publicKey,
        counter: counter,
        transports: transports,
      },
    });
  },

  async getCredentialByCredentialId(
    credentialId: string
  ): Promise<AuthenticatorDevice | null> {
    const credential = await prismaClient.credentials.findUnique({
      where: {
        credential_id: credentialId,
      },
    });
    if (!credential) return null;

    return {
      userID: credential.user_id,
      credentialID: base64ToUint8Array(credential.credential_id),
      credentialPublicKey: base64ToUint8Array(credential.public_key),
      counter: credential.counter,
      transports: credential.transports ? credential.transports.split(",") : [],
    } as AuthenticatorDevice;
  },

  async getCredentialsByUserId(userId: string) {
    return await prismaClient.credentials.findMany({
      where: {
        user_id: userId,
      },
    });
  },

  async updateCredentialCounter(credentialId: string, newCounter: number) {
    await prismaClient.credentials.update({
      where: {
        credential_id: credentialId,
      },
      data: {
        counter: newCounter,
      },
    });
  },
};
