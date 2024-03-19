import express from "express";
import userRouter from "./userRoutes.js";
const router = express.Router();


router.get("/ping", (req, res) => res.sendStatus(201));

router.use(userRouter);

export default router;
