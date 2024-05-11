import bcrypt from "bcryptjs";
import UserSchema from "../models/UserSchema.js";
import OTPSchema from "../models/OTPSchema.js";
import jwt from "jsonwebtoken";
import dotenv from "dotenv";
import nodemailer from "nodemailer";
import { uploadImage } from "./uploadService.js";
import Constants from "../utils/constants.js";
import { ObjectId } from "mongodb";
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
            margin: 0 auto;
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
    `;
};

const generateHtmlRenew = (username, otp) => {
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
              margin: 0 auto;
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
                Your New OTP!
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
                This is your new OTP to verify your account.
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
      `;
};

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
          margin: 0 auto;
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

const send_email_reset = (res, user, otp) => {
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
    success: "Add OTP to reset password",
    user_id: user._id,
  });
};
const send_email_register = (res, user, otp) => {
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
  });
};

const send_email_renew = (res, user, otp) => {
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
    subject: "Here your new OTP!",
    html: generateHtmlRenew(user.username, otp),
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
  });
};

const create_token = async (res, user) => {
  let tokenData;
  tokenData = { _id: user._id, email: user.email };

  const token = await generate_access_token(
    tokenData,
    process.env.JWT_SECRET,
    process.env.JWT_EXPIRE
  );
  return res
    .status(200)
    .json({ status: true, success: "Login Success", token: token });
};

const create_or_update_otp = async (user, otp) => {
  const expireOTP = new Date();
  expireOTP.setMinutes(expireOTP.getMinutes() + 1);
  const checkOTP = await OTPSchema.findOne({ userId: user._id });
  if (checkOTP) {
    await OTPSchema.findByIdAndUpdate(checkOTP._id, {
      otp: otp,
      expiresAt: expireOTP,
    });
  } else {
    const newOTP = new OTPSchema({
      userId: user._id,
      otp: otp,
      expiresAt: expireOTP,
    });
    await newOTP.save();
  }
};

const handle_register = async (req, res) => {
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
  await create_or_update_otp(user, OTP);
  return send_email_register(res, user, OTP);
};

const handle_renew_otp = async (email, res) => {
  const user = await UserSchema.findOne({ email });
  if (!user) {
    return res.status(404).send({
      errorCode: "2",
      message: "User not found",
    });
  }
  let OTP = await create_otp();
  await create_or_update_otp(user, OTP);
  return send_email_renew(res, user, OTP);
};

const handle_login_otp = async (otp, userId, res) => {
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
      message: "OTP is wrong or expired",
    });
  }

  return await create_token(res, user_in_db);
};

const handle_login = async (email, password, res) => {
  const user_in_db = await UserSchema.findOne({ email: email });
  if (!user_in_db) {
    return res.status(400).json({
      errorCode: "2",
      message: "User not found",
    });
  }
  const isPasswordValid = await verify_password(password, user_in_db.password);
  if (!isPasswordValid) {
    return res.status(400).json({
      errorCode: "3",
      message: "Password is not correct",
    });
  }

  return await create_token(res, user_in_db);
};

const handle_change_password = async (
  req,
  currentPassword,
  newPassword,
  res
) => {
  const user = await UserSchema.findById(req.user._id);
  if (!user) {
    return res.status(404).send({
      errorCode: "2",
      message: "User not found",
    });
  }
  const isPasswordValid = await verify_password(currentPassword, user.password);
  if (!isPasswordValid) {
    return res.status(400).send({
      errorCode: "3",
      message: "Current password is not correct",
    });
  }
  if (currentPassword === newPassword) {
    return res.status(400).send({
      errorCode: "3",
      message: "New password is the same as the current password",
    });
  }
  user.password = get_hashed_password(newPassword);
  await user.save();
  return res.status(200).send({
    status: true,
    success: "sendData",
    message: "Password changed successfully",
  });
};

const handle_create_otp = async (email, res) => {
  const user = await UserSchema.findOne({ email });

  if (!user) {
    return res.status(404).send({
      errorCode: "2",

      message: "User not found",
    });
  }
  let OTP = await create_otp();
  await create_or_update_otp(user, OTP);
  return send_email_reset(res, user, OTP);
};

const handle_verify_otp = async (otp, userId, res) => {
  const otp_in_db = await OTPSchema.findOne({ userId, otp });
  if (!otp_in_db) {
    return res.status(400).send({
      errorCode: "2",
      message: "OTP is wrong or expired",
    });
  }
  return res.status(200).send({
    status: true,
    success: "sendData",
    message: "OTP is correct",
  });
};

const handle_reset_password = async (userId, password, res) => {
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
};

const handle_update_profile = async (
  userId,
  fullname,
  phone,
  imagePath,
  res
) => {
  const user = await UserSchema.findById(userId);
  if (!user) {
    return res.status(404).send({
      errorCode: "2",
      message: "User not found",
    });
  }
  if (imagePath) {
    const uploadImageFile = await uploadImage(imagePath);
    user.image = uploadImageFile;
  }
  user.fullname = fullname;
  user.phone = phone;
  await user.save();
  return res.send({
    status: true,
    success: "sendData",
    message: "Profile updated successfully",
    data: user,
  });
};
const get_user = async (userId, res) => {
  const user = await UserSchema.findById(userId).select(
    "id email username fullname phone image level points"
  );

  if (!user) {
    return res.status(404).send({
      errorCode: "1",
      message: "User not found",
    });
  }
  return res.send({
    message: "Success",
    data: user,
  });
};

const update_points_user = async (userId, points) => {
  const user = await UserSchema.findById(userId);
  const constants = new Constants();

  if (!user) {
    return res.status(404).send({
      errorCode: "1",
      message: "User not found",
    });
  }
  user.points = user.points + points;
  const user_level = constants.getUserLevel(user.points);
  user.level = user_level;
  await user.save();
  return user;
};

export {
  handle_register,
  handle_login,
  handle_login_otp,
  handle_change_password,
  handle_create_otp,
  handle_verify_otp,
  handle_reset_password,
  handle_renew_otp,
  generate_access_token,
  get_hashed_password,
  verify_password,
  create_otp,
  send_email_reset,
  send_email_register,
  send_email_renew,
  create_or_update_otp,
  create_token,
  generateHtmlWelcome,
  generateHtmlRenew,
  generateHtmlReset,
  handle_update_profile,
  get_user,
  update_points_user,
};
