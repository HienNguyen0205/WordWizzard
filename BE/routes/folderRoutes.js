import express, { response } from "express";
import folderController from "../controllers/folderController.js";
import authentication from "../middleware/auth.js";
import flashCardController from "../controllers/flashCardController.js";
const router = express.Router();

// create folder
router.post("/api/folder/add", authentication,folderController.addOne);
// update folder
router.post("/api/folder/update/:id", authentication, folderController.updateOne);
// get folder detail
router.get("/api/folder/detail/:id", authentication, folderController.getOne);
// get all folder
router.get("/api/folder/all", authentication, folderController.getAll);
// // join flash card
// router.post(
//     "/api/flashcard/join/:topic_id",
//     authentication,
//     flashCardController.joinFlashCard
//   );
export default router;