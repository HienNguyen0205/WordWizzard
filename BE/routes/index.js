import express from "express";
import userRouter from "./userRoutes.js";
import folderRouter from "./folderRoutes.js";
import topicRouter from "./topicRoutes.js";
import topicFolderTopicRouter from "./topicFolderRoutes.js";
import userTopicRouter from "./userTopicRoutes.js";
const router = express.Router();


router.get("/ping", (req, res) => res.sendStatus(201));

router.use(userRouter);
router.use(folderRouter);
router.use(topicRouter);
router.use(topicFolderTopicRouter);
router.use(userTopicRouter);
export default router;
