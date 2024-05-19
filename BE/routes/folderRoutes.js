import express, { response } from "express";
import folderController from "../controllers/folderController.js";
import authentication from "../middleware/auth.js";
import flashCardController from "../controllers/userTopicController.js";
const router = express.Router();

// create folder
router.post("/api/folder/add", authentication,folderController.addOne);
// update folder
router.post("/api/folder/update/:id", authentication, folderController.updateOne);
// get folder detail
router.get("/api/folder/detail/:id", authentication, folderController.getOne);
// get all folder
router.get("/api/folder/all", authentication, folderController.getAll);
// delete folder
router.delete("/api/folder/delete/:id", authentication, folderController.deleteOne);
export default router;