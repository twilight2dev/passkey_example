import {
  generateAuthenticationOptions,
  verifyAuthenticationResponse,
} from "@simplewebauthn/server";
import { isoBase64URL } from "@simplewebauthn/server/helpers";
import {
  AuthenticatorTransportFuture
} from "@simplewebauthn/typescript-types";
import { NextFunction, Request, Response } from "express";
import { CustomError, sendResponse } from "../middleware/responseHandler";
import { credentialService } from "../services/credential.service";
import { userService } from "../services/user.service";
import { origin, relyingPartyID } from "../utils/const";
import { base64ToUint8Array, uint8ArrayToBase64 } from "../utils/utils";

export const initAuthenticate = async (
  req: Request,
  res: Response,
  next: NextFunction
) => {
  const { username } = req.body;
  if (!username) {
    return next(new CustomError("Username is empty", 400));
  }

  try {
    const user = await userService.getUserByUsername(username);
    if (!user) {
      return next(new CustomError("User not found", 404));
    }

    const credentials = await credentialService.getCredentialsByUserId(user.id);
    const options = await generateAuthenticationOptions({
      timeout: 60000,
      allowCredentials: credentials.map((credential) => ({
        id: base64ToUint8Array(credential.credential_id),
        type: "public-key",
        transports: credential.transports
          ? (credential.transports.split(",") as AuthenticatorTransportFuture[])
          : [],
      })),
      userVerification: "required",
      rpID: relyingPartyID,
    });
    req.session.userId = user.id;
    req.session.challange = options.challenge;
    sendResponse(options, res);
  } catch (error) {
    next(
      error instanceof CustomError
        ? error
        : new CustomError("Internal Server Error", 500)
    );
  }
};

export const completeAuthenticate = async (
  req: Request,
  res: Response,
  next: NextFunction
) => {
  const { id, rawId, clientDataJSON, authenticatorData, signature } = req.body;
  const { challange, userId } = req.session;

  if (!id || !rawId || !clientDataJSON || !authenticatorData || !signature) {
    return next(new CustomError("Body param is missing", 400));
  }

  if (!userId) {
    return next(new CustomError("UserId is missing", 400));
  }

  if (!challange) {
    return next(new CustomError("Challenge is missing", 400));
  }

  try {
    const credentialID = isoBase64URL.toBase64(rawId);
    const credentialIDBuffer = isoBase64URL.toBuffer(rawId);
    const credential = await credentialService.getCredentialByCredentialId(
      credentialID
    );
    if (!credential) {
      return next(
        new CustomError("Credential not registered with this site", 404)
      );
    }

    // @ts-ignore
    const user = await userService.getUserById(credential.userID);
    if (!user) {
      return next(new CustomError("User not found", 404));
    }

    let verification = await verifyAuthenticationResponse({
      expectedChallenge: challange,
      expectedOrigin: origin,
      expectedRPID: relyingPartyID,
      authenticator: credential,
      response: {
        id: id,
        rawId: rawId,
        type: "public-key",
        response: {
          authenticatorData: authenticatorData,
          clientDataJSON: clientDataJSON,
          signature: signature,
        },
        clientExtensionResults: {},
      },
    });
    if (verification.verified && verification.authenticationInfo) {
      const authenticationInfo = verification.authenticationInfo;
      await credentialService.updateCredentialCounter(
        uint8ArrayToBase64(credentialIDBuffer),
        authenticationInfo.newCounter
      );
      sendResponse({ idToken: "" }, res);
    } else {
      next(new CustomError("Verification failed", 400));
    }
  } catch (error) {
    next(
      error instanceof CustomError
        ? error
        : new CustomError("Internal Server Error", 500)
    );
  } finally {
    req.session.challange = undefined;
    req.session.userId = undefined;
  }
};
