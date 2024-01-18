import { uint8ArrayToBase64 } from "./../utils/utils";
import {
  generateRegistrationOptions,
  verifyRegistrationResponse,
} from "@simplewebauthn/server";
import { relyingPartyName, relyingPartyID, origin } from "../utils/const";
import { credentialService } from "../services/credential.service";
import { userService } from "../services/user.service";
import { Request, Response, NextFunction } from "express";
import { CustomError, sendResponse } from "../middleware/responseHandler";

export const initRegister = async (
  req: Request,
  res: Response,
  next: NextFunction
) => {
  const { username } = req.body;
  if (!username) {
    return next(new CustomError("Username is empty", 400));
  }

  try {
    let user = await userService.getUserByUsername(username);
    if (user) {
      if (user.registered) {
        return next(new CustomError("User already exists", 400));
      } else {
        await userService.removeUserWithUsername(username);
      }
    }
    user = await userService.createNewUser(username);

    // Clears the stored challenge for the session, creates the register options for the client
    req.session.challange = undefined;
    req.session.userId = undefined;
    const options = await generateRegistrationOptions({
      rpName: relyingPartyName,
      rpID: relyingPartyID,
      userID: Buffer.from(user.id).toString("base64"),
      userName: user.username,
      timeout: 60000,
      attestationType: "none",
      excludeCredentials: [],
      authenticatorSelection: {
        authenticatorAttachment: "platform",
        userVerification: "required",
        residentKey: "preferred",
        requireResidentKey: false,
      },
      // Support for the two most common algorithms: ES256, and RS256
      supportedAlgorithmIDs: [-7, -257],
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

export const completeRegister = async (
  req: Request,
  res: Response,
  next: NextFunction
) => {
  const { id, rawId, clientDataJSON, attestationObject } = req.body;
  const { challange, userId } = req.session;

  if (!id || !rawId || !clientDataJSON || !attestationObject) {
    return next(new CustomError("Body param is missing", 400));
  }

  if (!userId) {
    return next(new CustomError("UserId is missing", 400));
  }

  if (!challange) {
    return next(new CustomError("Challenge is missing", 400));
  }

  try {
    const verification = await verifyRegistrationResponse({
      expectedChallenge: challange,
      expectedOrigin: origin,
      expectedRPID: relyingPartyID,
      requireUserVerification: true,
      response: {
        id: id,
        rawId: rawId,
        type: "public-key",
        response: {
          clientDataJSON: clientDataJSON,
          attestationObject: attestationObject,
        },
        clientExtensionResults: {},
      },
    });

    if (verification.verified && verification.registrationInfo) {
      const registrationInfo = verification.registrationInfo;
      await credentialService.createNewCredential(
        userId,
        uint8ArrayToBase64(registrationInfo.credentialID),
        uint8ArrayToBase64(registrationInfo.credentialPublicKey),
        registrationInfo.counter,
        null
      );
      await userService.markUserAsRegistered(userId);
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
    req.session.userId = undefined;
    req.session.challange = undefined;
  }
};
