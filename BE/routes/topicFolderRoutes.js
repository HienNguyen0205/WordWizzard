import express, { response } from "express";
import topicFolderController from "../controllers/topicFolderController.js";
import authentication from "../middleware/auth.js";
const router = express.Router();

// Update topics to folder
router.post(
  "/api/folder/update-topics/:id",
  authentication,
  topicFolderController.updateTopicsToFolder
);

// Choose folders to add topics
router.post(
  "/api/topic/choose-folders/:id",
  authentication,
  topicFolderController.chooseFoldersToAdd
);

// Get all folders and chosen folders
router.get(
  "/api/topic/get-folders/:id",
  authentication,
  topicFolderController.getFolders
);

// Get all topics and chosen topics
router.get(
  "/api/folder/get-topics/:id",
  authentication,
  topicFolderController.getTopics
);
export default router;
