import express, { response } from "express";
import authentication from "../middleware/auth.js";
import flashCardController from "../controllers/flashCardController.js";
const router = express.Router();

// join flash card
router.post(
    "/api/flashcard/join/:topic_id",
    authentication,
    flashCardController.joinFlashCard
  );
export default router;