import express, { Express } from "express";
import morgan from "morgan";
import helmet from "helmet";
import cors from "cors";
import config from "../config.json";
import { router as passkeyRoutes } from "./routes/routes";
import session from "express-session";
import { isoBase64URL } from "@simplewebauthn/server/helpers";

const app: Express = express();
app.enable("trust proxy");

declare module "express-session" {
  interface SessionData {
    challange?: string;
    userId?: string;
  }
}

/************************************************************************************
 *                              Basic Express Middlewares
 ***********************************************************************************/
app.set("json spaces", 4);
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.use(
  session({
    // @ts-ignore
    secret: process.env.SESSION_SECRET,
    saveUninitialized: true,
    resave: false,
    cookie: {
      maxAge: 86400000,
      httpOnly: true,
    },
  })
);

app.use(morgan("dev"));
app.use(cors());

/************************************************************************************
 *                               Auth Routes
 ***********************************************************************************/
app.use("/api/auth", passkeyRoutes);
app.get("/.well-known/apple-app-site-association", (request, response) => {
  response.sendFile(__dirname + "/public/apple-app-site-association");
});

app.get("/get_session", (req, res) => {
  //check session
  let a = "O1MpFsXN8GQO9SIgAJR3KHm5nOo";
  let b = Buffer.from(a).toString("base64");
  let c = isoBase64URL.toBase64(a);
  let d = isoBase64URL.toBuffer(a);
  return res.status(200).json({ status: "success", a, b, c, d });
});

export default app;
