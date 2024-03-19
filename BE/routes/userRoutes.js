import express, { response } from "express";
import controller from "../controllers/userController.js";
const router = express.Router();

// add new user
router.post("/api/user", controller.addOne);

// get all users
router.get("/api/user", controller.getAll);
export default router;