import bcrypt from "bcryptjs";
import UserSchema from "../models/UserSchema.js";
import OTPSchema from "../models/OTPSchema.js";
const userController = {};
import jwt from "jsonwebtoken";
import dotenv from "dotenv";
import nodemailer from "nodemailer";
dotenv.config();
const generateHtmlWelcome = (username, otp) => {
  return `
    <html lang="en">
    <head>
      <meta charset="UTF-8" />
      <meta name="viewport" content="width=device-width, initial-scale=1.0" />
      <title>Document</title>
      <link rel="preconnect" href="https://fonts.googleapis.com" />
      <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
      <link
        href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:ital,wght@0,200..800;1,200..800&display=swap"
        rel="stylesheet"
      />
      <style>
        .dot:after {
          content: "";
          width: 5px;
          height: 5px;
          border-radius: 50%;
          margin: 0 4px;
          background: #7a7a7a;
          display: inline-block;
        }
      </style>
    </head>
    <body>
      <table
        style="
          font-family: 'Plus Jakarta Sans', sans-serif;
          width: 680px;
          height: 680px;
          background-color: white;
          padding: 32px 48px;
          border-radius: 12px;
        "
      >
        <tbody style="width: 100%; height: 100%">
          <tr>
            <td style="text-align: center">
              <img
                src="https://res.cloudinary.com/dtrtjisrv/image/upload/f_auto,q_auto/v1/logo/iu1leiumuyoyu7qunsrg"
                alt=""
                style="max-width: 200px; height: auto; margin: 0 auto"
              />
            </td>
          </tr>
          <tr>
              <td style="text-align: center">
                <img
                  src="https://res.cloudinary.com/dtrtjisrv/image/upload/f_auto,q_auto/v1/banner/dwvp5langlcr1wcirlbu"
                  alt=""
                  style="width: 600px; height: 300px; margin: 0 auto; border-radius: 20px;"
                />
              </td>
            </tr>
          <tr>
            <td style="text-align: center; ">
              <h1
                style="
                  font-size: 24px;
                  font-weight: 700;
                  line-height: 32px;
                  margin: 0px;
                  margin-top: 40px;
                "
              >
                Welcome to WordWizard!
              </h1>
            </td>
          </tr>
          <tr>
            <td>
              <h3
                style="
                  line-height: 28px;
                  font-weight: 700;
                  font-size: 20px;
                  margin: 0px;
                  margin-top: 24px;
                "
              >
                Hi ${username},
              </h3>
            </td>
          </tr>
          <tr>
            <td>
              <p
                style="
                  line-height: 20px;
                  font-weight: 300;
                  font-size: 14px;
                  margin: 0px;
                  margin-top: 24px;
                "
              >
                Congratulations! You now have an account on WordWizard! Here is the code to verify your account.
              </p>
            </td>
          </tr>
          <tr>
            <td>
              <h1
                style="letter-spacing: 20px; font-size: 40px; text-align: center"
              >
                ${otp}
              </h1>
            </td>
          </tr>
          <tr>
            <td>
              <p
                style="
                  line-height: 20px;
                  font-weight: 300;
                  font-size: 14px;
                  margin: 0px;
                  margin-top: 24px;
                "
              >
                  Thank you for choosing WordWizard. We look forward to seeing the amazing content that you will create.
              </p>
            </td>
          </tr>
          <tr>
            <td>
              <p
                style="
                  line-height: 20px;
                  font-weight: 300;
                  font-size: 14px;
                  margin: 0px;
                  margin-top: 24px;
                  margin-bottom: 24px;
                "
              >
                Best Regards,<br />
                <span style="font-weight: 600; font-size: 14px; color: #121212"
                  >WordWizard team.</span
                >
              </p>
            </td>
          </tr>
          <tr>
            <td style="background: #e8e6f6d6"></td>
          </tr>
          <tr>
            <td style="text-align: center; vertical-align: middle">
              <span style="margin: 0 8px">
                <img
                  style="margin: 8px 0 4px 0; width: 40px; height: 40px"
                  src="https://cdn-icons-png.flaticon.com/512/20/20673.png"
                  alt="ICON"
                />
              </span>
              <span style="margin: 0 8px">
                <img
                  style="margin: 8px 0 4px 0; width: 40px; height: 40px"
                  src="https://cdn-icons-png.flaticon.com/512/1362/1362894.png"
                  alt="ICON"
                />
              </span>
              <span style="margin: 0 8px">
                <img
                  style="margin: 8px 0 4px 0; width: 40px; height: 40px"
                  src="https://cdn-icons-png.flaticon.com/512/25/25231.png"
                  alt="ICON"
                />
              </span>
            </td>
          </tr>
          <tr>
            <td style="background: #e8e6f6d6"></td>
          </tr>

          <tr>
            <td style="text-align: center; vertical-align: middle">
              <p
                style="
                  margin: 0;
                  margin-top: 16px;
                  font-size: 10px;
                  font-weight: 200;
                  line-height: 12.6px;
                "
              >
                © 2024 WordWizard. All rights reserved.
              </p>
            </td>
          </tr>

          <tr>
            <td style="text-align: center; vertical-align: middle; width: 476px">
              <p
                style="
                  margin: 0;
                  margin-top: 24px;
                  font-size: 10px;
                  font-weight: 200;
                  line-height: 16px;
                "
              >
                You are receiving this mail because you registered to join the
                WordWizard platform as a user or a creator. This also shows that
                you agree to our Terms of use and Privacy Policies. If you no
                longer want to receive mails from use, click the unsubscribe link
                below to unsubscribe.
              </p>
            </td>
          </tr>

          <tr>
            <td style="text-align: center; vertical-align: middle">
              <a
                class="dot"
                style="font-size: 10px; font-weight: 500; line-height: 12.6px"
              >
                Xuan Binh
              </a>
              <a
                class="dot"
                style="font-size: 10px; font-weight: 500; line-height: 12.6px"
              >
                Mai Duy
              </a>
              
              <a style="font-size: 10px; font-weight: 500; line-height: 12.6px">
                Cong Hien
              </a>
            </td>
          </tr>
        </tbody>
      </table>
    </body>
  </html>
  `
}
const generateHtmlReset = (username, otp) => {
  return `
  <html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Document</title>
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link
      href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:ital,wght@0,200..800;1,200..800&display=swap"
      rel="stylesheet"
    />
    <style>
      .dot:after {
        content: "";
        width: 5px;
        height: 5px;
        border-radius: 50%;
        margin: 0 4px;
        background: #7a7a7a;
        display: inline-block;
      }
    </style>
  </head>
  <body>
    <table
      style="
        font-family: 'Plus Jakarta Sans', sans-serif;
        width: 680px;
        height: 680px;
        background-color: white;
        padding: 32px 48px;
      "
    >
      <tbody style="width: 100%; height: 100%">
        <tr>
          <td style="text-align: center">
            <img
              src="https://res.cloudinary.com/dtrtjisrv/image/upload/f_auto,q_auto/v1/logo/iu1leiumuyoyu7qunsrg"
              alt=""
              style="max-width: 200px; height: auto; margin: 0 auto"
            />
          </td>
        </tr>
        <tr>
          <td style="text-align: center">
            <h1
              style="
                font-size: 24px;
                font-weight: 700;
                line-height: 32px;
                margin: 0px;
                margin-top: 24px;
              "
            >
              Reset your password
            </h1>
          </td>
        </tr>
        <tr>
          <td>
            <h3
              style="
                line-height: 28px;
                font-weight: 700;
                font-size: 20px;
                margin: 0px;
                margin-top: 24px;
              "
            >
              Hi ${username},
            </h3>
          </td>
        </tr>
        <tr>
          <td>
            <p
              style="
                line-height: 20px;
                font-weight: 300;
                font-size: 14px;
                margin: 0px;
                margin-top: 24px;
              "
            >
              You have requested us to send a OTP to reset your password for
              your WordWizard account, here it is.
            </p>
          </td>
        </tr>
        <tr>
          <td>
            <h1
            style="letter-spacing: 20px; font-size: 40px; text-align: center">${otp}</h1>
          </td>
        </tr>
        <tr>
          <td>
            <p
              style="
                line-height: 20px;
                font-weight: 300;
                font-size: 14px;
                margin: 0px;
                margin-top: 24px;
              "
            >
              If you didn’t initiate the request, you can safely ignore the mail
            </p>
          </td>
        </tr>
        <tr>
          <td>
            <p
              style="
                line-height: 20px;
                font-weight: 300;
                font-size: 14px;
                margin: 0px;
                margin-top: 24px;
                margin-bottom: 24px;
              "
            >
              Best Regards,<br />
              <span style="font-weight: 600; font-size: 14px; color: #121212"
                >WordWizard team.</span
              >
            </p>
          </td>
        </tr>
        <tr>
          <td style="background: #e8e6f6d6"></td>
        </tr>
        <tr>
          <td style="text-align: center; vertical-align: middle">
            <span style="margin: 0 8px">
              <img
                style="margin: 8px 0 4px 0; width: 40px; height: 40px;"
                src="https://cdn-icons-png.flaticon.com/512/20/20673.png"
                alt="ICON"
              />
            </span>
            <span style="margin: 0 8px">
              <img
                style="margin: 8px 0 4px 0; width: 40px; height: 40px"
                src="https://cdn-icons-png.flaticon.com/512/1362/1362894.png"
                alt="ICON"
              />
            </span>
            <span style="margin: 0 8px">
              <img
                style="margin: 8px 0 4px 0; width: 40px; height: 40px"
                src="https://cdn-icons-png.flaticon.com/512/25/25231.png"
                alt="ICON"
              />
            </span>
          </td>
        </tr>
        <tr>
          <td style="background: #e8e6f6d6"></td>
        </tr>

        <tr>
          <td style="text-align: center; vertical-align: middle">
            <p
              style="
                margin: 0;
                margin-top: 16px;
                font-size: 10px;
                font-weight: 200;
                line-height: 12.6px;
              "
            >
              © 2024 WordWizard. All rights reserved.
            </p>
          </td>
        </tr>

        <tr>
          <td style="text-align: center; vertical-align: middle; width: 476px">
            <p
              style="
                margin: 0;
                margin-top: 24px;
                font-size: 10px;
                font-weight: 200;
                line-height: 16px;
              "
            >
              You are receiving this mail because you registered to join the
              WordWizard platform as a user or a creator. This also shows that you
              agree to our Terms of use and Privacy Policies. If you no longer
              want to receive mails from use, click the unsubscribe link below
              to unsubscribe.
            </p>
          </td>
        </tr>

        <tr>
        <td style="text-align: center; vertical-align: middle">
        <a
          class="dot"
          style="font-size: 10px; font-weight: 500; line-height: 12.6px"
        >
          Xuan Binh
        </a>
        <a
          class="dot"
          style="font-size: 10px; font-weight: 500; line-height: 12.6px"
        >
          Mai Duy
        </a>
        
        <a style="font-size: 10px; font-weight: 500; line-height: 12.6px">
          Cong Hien
        </a>
      </td>
        </tr>
      </tbody>
    </table>
  </body>
</html>
  `;
};

const get_hashed_password = (password) => {
  return bcrypt.hashSync(password, 8);
};

const verify_password = (plain_password, hashed_password) => {
  return bcrypt.compare(plain_password, hashed_password);
};

const generate_access_token = (tokenData, JWTSecret_Key, JWT_EXPIRE) => {
  return jwt.sign(tokenData, JWTSecret_Key, { expiresIn: JWT_EXPIRE });
};

const create_otp = async () => {
  let digits = "0123456789";
  let OTP = "";
  for (let i = 0; i < 6; i++) {
    OTP += digits[Math.floor(Math.random() * 10)];
  }
  return OTP;
};

const send_email_reset = async (res, user, otp) => {
  var transporter = nodemailer.createTransport({
    service: "gmail",
    auth: {
      user: process.env.EMAIL,
      pass: process.env.PASSWORD,
    },
  });
  var mailOptions = {
    from: process.env.EMAIL,
    to: user.email,
    subject: "Reset Password",
    html: generateHtmlReset(user.username, otp),
  };
  transporter.sendMail(mailOptions, function (error, info) {
    if (error) {
      console.log(error);
      return res.status(500).send("Error sending email");
    }
  });
  return res.status(200).send({
    status: true,
    success: "sendData",
    user_id: user._id,
    otp: otp,
  });
};
const send_email_register = async (res, user, otp) => {
  var transporter = nodemailer.createTransport({
    service: "gmail",
    auth: {
      user: process.env.EMAIL,
      pass: process.env.PASSWORD,
    },
  });
  var mailOptions = {
    from: process.env.EMAIL,
    to: user.email,
    subject: "Welcome to WordWizard!",
    html: generateHtmlWelcome(user.username, otp),
  };
  transporter.sendMail(mailOptions, function (error, info) {
    if (error) {
      console.log(error);
      return res.status(500).send("Error sending email");
    }
  });
  return res.status(200).send({
    status: true,
    message: "Add OTP to verify your account",
    user_id: user._id,
    otp: otp,
  });
};

// Register
userController.register = async (req, res, next) => {
  try {
    if (!req.body.username || !req.body.email || !req.body.password) {
      return res.status(400).send({
        errorCode: "1",
        message: "Username, email, and password are required.",
      });
    }

    const user_in_db = await UserSchema.findOne({ email: req.body.email });

    if (user_in_db) {
      return res
        .status(400)
        .json({ errorCode: "2", message: "User already exists" });
    }

    const newUser = new UserSchema({
      username: req.body.username,
      email: req.body.email,
      password: get_hashed_password(req.body.password),
    });

    const user = await newUser.save();
    const OTP = await create_otp();
    const expireOTP = new Date();
    expireOTP.setMinutes(expireOTP.getMinutes() + 3);
    const newOTP = new OTPSchema({
      userId: user._id,
      otp: OTP,
      expiresAt: expireOTP,
    });
    await newOTP.save();
    return await send_email_register(res, user, OTP);
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
    const user_in_db = await UserSchema.findById(userId);
    if (!user_in_db) {
      return res.status(400).json({
        errorCode: "2",
        message: "User not found",
      });
    }
    const otp_in_db = await OTPSchema.findOne({ userId: userId, otp });
    if (!otp_in_db) {
      return res.status(400).json({
        errorCode: "3",
        message: "OTP is not correct",
      });
    }
    if (otp_in_db.expiresAt < new Date()) {
      return res.status(400).json({
        errorCode: "4",
        message: "OTP is expired",
      });
    }

    let tokenData;
    tokenData = { _id: user_in_db._id, email: user_in_db.email };

    const token = await generate_access_token(
      tokenData,
      process.env.JWT_SECRET,
      process.env.JWT_EXPIRE
    );
    return res
      .status(200)
      .json({ status: true, success: "sendData", token: token });
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
    const user_in_db = await UserSchema.findOne({ email: req.body.email });
    if (!user_in_db) {
      return res.status(400).json({
        errorCode: "2",
        message: "User not found",
      });
    }
    const isPasswordValid = await verify_password(
      password,
      user_in_db.password
    );
    if (!isPasswordValid) {
      return res.status(400).json({
        errorCode: "3",
        message: "Password is not correct",
      });
    }
    let tokenData;
    tokenData = { _id: user_in_db._id, email: user_in_db.email };

    const token = await generate_access_token(
      tokenData,
      process.env.JWT_SECRET,
      process.env.JWT_EXPIRE
    );
    return res
      .status(200)
      .json({ status: true, success: "sendData", token: token });
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
    const user = await UserSchema.findById(req.user._id)
    if (!user) {
      return res.status(404).send({
        errorCode: "2",
        message: "User not found",
      });
    }
    const isPasswordValid = await verify_password(
      currentPassword,
      user.password
    );
    if (!isPasswordValid) {
      return res.status(400).send({
        errorCode: "3",
        message: "Current password is not correct",
      });
    }
    user.password = get_hashed_password(newPassword);
    await user.save();
    return res.status(200).send({
      status: true,
      success: "sendData",
      message: "Password changed successfully",
    });
  } catch (error) {
    next(error);
  }
}
// Create OTP
userController.createOTP = async (req, res, next) => {
  const { email } = req.body;
  try {
    const user = await UserSchema.findOne({ email });
    const expireOTP = new Date();
    expireOTP.setMinutes(expireOTP.getMinutes() + 3);

    if (!user) {
      return res.status(404).send({
        errorCode: "1",
        message: "User not found",
      });
    }
    let OTP = await create_otp();
    const checkOTP = await OTPSchema.findOne({ userId: user._id });
    if (checkOTP) {
      await OTPSchema.findByIdAndUpdate(checkOTP._id, {
        otp: OTP,
        expiresAt: expireOTP,
      });
    } else {
      const newOTP = new OTPSchema({
        userId: user._id,
        otp: OTP,
        expiresAt: expireOTP,
      });
      await newOTP.save();
    }
    return await send_email_reset(res, user, OTP);
  } catch (error) {
    next(error);
  }
};

// Verify OTP
userController.verifyOTP = async (req, res, next) => {
  const { otp } = req.body;
  const userId = req.params.id;
  try {
    if (!otp) {
      return res.status(400).send({
        errorCode: "1",
        message: "OTP is required",
      });
    }
    const otp_in_db = await OTPSchema.findOne({ userId, otp });
    if (!otp_in_db) {
      return res.status(400).send({
        errorCode: "2",
        message: "OTP is not correct",
      });
    }
    if (otp_in_db.expiresAt < new Date()) {
      return res.status(400).send({
        errorCode: "3",
        message: "OTP is expired",
      });
    }
    return res.status(200).send({
      status: true,
      success: "sendData",
      message: "OTP is correct",
    });
  } catch (error) {
    next(error);
  }
};

// Reset password
userController.resetPassword = async (req, res, next) => {
  const userId = req.params.id;
  const { password } = req.body;
  try {
    if (!password) {
      return res.status(400).send({
        errorCode: "1",
        message: "Password is required",
      });
    }
    const user = await UserSchema.findById(userId);
    if (!user) {
      return res.status(404).send({
        errorCode: "2",
        message: "User not found",
      });
    }
    user.password = get_hashed_password(password);
    await user.save();
    return res.send({
      status: true,
      success: "sendData",
      message: "Password reset successfully",
    });
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
