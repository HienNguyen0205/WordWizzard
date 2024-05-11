import express, { response } from "express";
import authentication from "../middleware/auth.js";
import userTopicController from "../controllers/userTopicController.js";
const router = express.Router();

// join topic
router.post(
  "/api/userTopic/join/:topic_id",
  authentication,
  userTopicController.joinTopic
);

// save topic words mark
router.post(
  "/api/userTopic/save/:topic_id",
  authentication,
  userTopicController.saveTopic
);

// claim topic quiz
router.post(
  "/api/userTopic/finish/:topic_id",
  authentication,
  userTopicController.finishTopicQuiz
)
export default router;
