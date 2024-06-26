import express, { response } from "express";
import userController from "../controllers/userController.js";
import authentication from "../middleware/auth.js";
import upload from "../middleware/multer.js";
import cloudinary from "../utils/cloudinary.js";
const router = express.Router();

// register
router.post("/api/user/register", userController.register);
// login
router.post("/api/user/login", userController.login);
// login with OTP
router.post("/api/user/login-otp/:id", userController.loginOtp);
// change password
router.post("/api/user/change-password", authentication, userController.changePassword);
// me
router.get("/api/user/me", authentication, userController.me);
// create OTP
router.post("/api/user/otp", userController.createOTP);
// verify OTP
router.post("/api/user/verify-otp/:id", userController.verifyOTP);
// reset password
router.post("/api/user/reset-password/:id", userController.resetPassword);
// renew otp
router.post("/api/user/renew-otp", userController.renewOTP);
// update profile
router.post("/api/user/update-profile", authentication, userController.updateProfile);
// upload image
router.post("/api/user/upload-image", authentication, upload.single("image"), userController.uploadImage);
// leaderboard
router.get("/api/user/leaderboard", userController.leaderboard);
export default router;
