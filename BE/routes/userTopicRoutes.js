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

// join flash card
router.get(
  "/api/userTopic/joinFlashCard/:topic_id",
  authentication,
  userTopicController.joinFlashCard
);

// reset flash card
router.post(
  "/api/userTopic/resetFlashCard/:topic_id",
  authentication,
  userTopicController.resetFlashCard
);
export default router;
