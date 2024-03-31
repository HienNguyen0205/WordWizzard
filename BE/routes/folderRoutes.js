import express, { response } from "express";
import folderController from "../controllers/folderController.js";
import authentication from "../middleware/auth.js";
const router = express.Router();

// create folder
router.post("/api/folder/add", authentication,folderController.addOne);
// get folder detail
router.get("/api/folder/detail/:id", authentication, folderController.getOne);
// get all folder
router.get("/api/folder/all", authentication, folderController.getAll);
// update topics to folder


// // change password
// router.post("/api/user/change-password", authentication, userController.changePassword);
// // me
// router.get("/api/user/me", authentication, userController.me);
// // create OTP
// router.post("/api/user/otp", userController.createOTP);
// // verify OTP
// router.post("/api/user/verify-otp/:id", userController.verifyOTP);
// // reset password
// router.post("/api/user/reset-password/:id", userController.resetPassword);
// // renew otp
// router.post("/api/user/renew-otp", userController.renewOTP);
export default router;