import express, { Express, NextFunction, Request, Response } from "express";
import { config } from "dotenv";
import logger from "morgan";
import cors from "cors";
import createError from "http-errors"

config();
const app: Express = express();
app.use(logger("dev"));
app.use(cors());

app.get("/", (req: Request, res: Response) => {
    return res.status(200).json({"Hey": "lets scale express on k8s"})
})

// error handling
app.use(async (req: Request, res: Response, next: NextFunction) => {
  const error = createError.NotFound("The page does not exist");
  next(error);
});

app.use(async (error: any, req: Request, res: Response, next: NextFunction) => {
  const status = error.status || 500;
  res.status(status).json({
    message: error.message,
    status: error.status,
  });
});

const port = process.env.PORT || 3000;

app.listen(port, () => {
  console.info(`app is runnning on http://localhost:${port}`);
});
