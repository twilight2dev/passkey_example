import express from "express";
import { handleError } from "../middleware/responseHandler";
import {
  initRegister,
  completeRegister,
} from "../controllers/registration.controller";
import {
  initAuthenticate,
  completeAuthenticate,
} from "../controllers/authentication.controller";

const router = express.Router();

router.post("/initRegister", initRegister);
router.post("/completeRegister", completeRegister);
router.post("/initAuthenticate", initAuthenticate);
router.post("/completeAuthenticate", completeAuthenticate);

router.use(handleError);

export { router };
