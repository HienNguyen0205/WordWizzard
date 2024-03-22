import express, { response } from "express";
import userController from "../controllers/userController.js";
import authentication from "../middleware.js";
const router = express.Router();

// register
router.post("/api/user/register", userController.register);
// login
router.post("/api/user/login", userController.login);
// me
router.get("/api/user/me", authentication, userController.me);


export default router;