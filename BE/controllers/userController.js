import UserSchema from "../models/UserSchema.js";
import * as userService from "../services/userService.js";

const userController = {};

// Register
userController.register = async (req, res, next) => {
  try {
    if (!req.body.username || !req.body.email || !req.body.password) {
      return res.status(400).send({
        errorCode: "1",
        message: "Username, email, and password are required.",
      });
    }
    return await userService.handle_register(req, res);
  } catch (error) {
    next(error);
  }
};

// Renew OTP
userController.renewOTP = async (req, res, next) => {
  try {
    const { email } = req.body;
    if (!email) {
      return res.status(400).send({
        errorCode: "1",
        message: "Email is required",
      });
    }
    return await userService.handle_renew_otp(email, res);
  } catch (error) {
    next(error);
  }
};
// Login with OTP
userController.loginOtp = async (req, res, next) => {
  try {
    const { otp } = req.body;
    const userId = req.params.id;
    if (!userId || !otp) {
      return res.status(400).json({
        errorCode: "1",
        message: "UserId and OTP are required",
      });
    }
    return await userService.handle_login_otp(otp, userId, res);
  } catch (error) {
    next(error);
  }
};

// Login
userController.login = async (req, res, next) => {
  try {
    const { email, password } = req.body;
    if (!email || !password) {
      return res.status(400).json({
        errorCode: "1",
        message: "Email and password are required",
      });
    }
    return await userService.handle_login(email, password, res);
  } catch (error) {
    next(error);
  }
};

// Change password
userController.changePassword = async (req, res, next) => {
  const { currentPassword, newPassword } = req.body;
  try {
    if (!currentPassword || !newPassword) {
      return res.status(400).send({
        errorCode: "1",
        message: "Current password and new password are required",
      });
    }
    return await userService.handle_change_password(
      req,
      currentPassword,
      newPassword,
      res
    );
  } catch (error) {
    next(error);
  }
};

// Create OTP
userController.createOTP = async (req, res, next) => {
  try {
    const { email } = req.body;
    if (!email) {
      return res.status(400).send({
        errorCode: "1",
        message: "Email is required",
      });
    }
    return await userService.handle_create_otp(email, res);
  } catch (error) {
    next(error);
  }
};

// Verify OTP
userController.verifyOTP = async (req, res, next) => {
  try {
    const { otp } = req.body;
    const userId = req.params.id;
    if (!otp) {
      return res.status(400).send({
        errorCode: "1",
        message: "OTP is required",
      });
    }
    return await userService.handle_verify_otp(otp, userId, res);
  } catch (error) {
    next(error);
  }
};

// Reset password
userController.resetPassword = async (req, res, next) => {
  try {
    const userId = req.params.id;
    const { password } = req.body;
    if (!password || !userId) {
      return res.status(400).send({
        errorCode: "1",
        message: "Password and User Id is required",
      });
    }
    return await userService.handle_reset_password(userId, password, res);
  } catch (error) {
    next(error);
  }
};

// Update Profile
userController.updateProfile = async (req, res, next) => {
  try {
    const userId = req.user._id;
    const imagePath = req.file.path;
    const { fullname, phone } = req.body;
    if (!userId) {
      return res.status(400).send({
        errorCode: "1",
        message: "User Id is required",
      });
    }
    return await userService.handle_update_profile(userId, fullname, phone, imagePath, res);
  } catch (error) {
    next(error);
  }
};
// Me
userController.me = async (req, res, next) => {
  try {
    const user = await UserSchema.findById(req.user._id).select(
      "id email username"
    );
    if (!user) {
      return res.status(404).send({
        errorCode: "1",
        message: "User not found",
      });
    }
    return res.send(user);
  } catch (error) {
    next(error);
  }
};

// userController.getAll = async (req, res, next) => {
//   try {
//     const { search, page, limit } = req.query;
//     let queryObject = {};
//     let sortObject = { createdAt: -1 };
//     if (search) {
//       queryObject.$or = [
//         { name: { $regex: `${search}`, $options: "i" } },
//         { description: { $regex: `${search}`, $options: "i" } },
//       ];
//     }

//     const pages = Number(page);
//     const limits = Number(limit);
//     const skip = (pages - 1) * limits;

//     const totalDoc = await UserSchema.countDocuments(queryObject);

//     const data = await UserSchema.find(queryObject)
//       .sort(sortObject)
//       .skip(skip)
//       .limit(limits);

//     return res.send({
//       data,
//       totalDoc,
//       limits,
//       pages,
//     });
//   } catch (err) {
//     next(err);
//   }
// };
export default userController;
