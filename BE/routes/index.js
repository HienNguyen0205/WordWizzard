import express from "express";
import userRouter from "./userRoutes.js";
import folderRouter from "./folderRoutes.js";
import topicRouter from "./topicRoutes.js";
import topicFolderTopic from "./topicFolderRoutes.js";
const router = express.Router();


router.get("/ping", (req, res) => res.sendStatus(201));

router.use(userRouter);
router.use(folderRouter);
router.use(topicRouter);
router.use(topicFolderTopic);

export default router;
