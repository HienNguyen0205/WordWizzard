import bcrypt from "bcryptjs";
import UserSchema from "../models/UserSchema.js";
const userController = {};
import jwt from "jsonwebtoken";
import dotenv from 'dotenv'
dotenv.config();
// def get_hashed_password(password: str) -> str:
//     return pwd_context.hash(password)

// def verify_password(plain_password: str, hashed_password: str) -> bool:
//     return pwd_context.verify(plain_password, hashed_password)

const get_hashed_password = (password) => {
  return bcrypt.hashSync(password, 8);
};
const verify_password = (plain_password, hashed_password) => {
  return bcrypt.compare(plain_password, hashed_password);
};
const generate_access_token = (tokenData, JWTSecret_Key, JWT_EXPIRE) => {
  return jwt.sign(tokenData, JWTSecret_Key, { expiresIn: JWT_EXPIRE });
};

userController.register = async (req, res, next) => {
  try {
    if (!req.body.username || !req.body.email || !req.body.phone) {
      return res.status(400).send("Username, email, and phone are required.");
    }

    const user_in_db = await UserSchema.findOne({ email: req.body.email });

    if (user_in_db) {
      return res.status(400).json({ error: "email already exists" });
    }

    const newUser = new UserSchema({
      username: req.body.username,
      email: req.body.email,
      phone: req.body.phone,
      password: get_hashed_password(req.body.password),
    });

    const user = await newUser.save();
    return res.status(201).send({
      message: "User added successfully",
      data: user,
    });
  } catch (error) {
    next(error);
  }
};

userController.login = async (req, res, next) => {
  try {
    const { email, password } = req.body;
    if (!email || !password) {
      return res.status(400).json({ error: "Parameter are not correct" });
    }
    const user_in_db = await UserSchema.findOne({ email: req.body.email });
    if (!user_in_db) {
      return res.status(400).json({ error: "User does not exist" });
    }
    const isPasswordValid = await verify_password(password,user_in_db.password);
    if (!isPasswordValid) {
      return res.status(400).json({ error: "Password is not correct" });
    }

    // Create a token
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

userController.me = async (req, res, next) => {
  try {
    const user = await UserSchema.findById(req.user._id).select("id email username phone");
    if (!user) {
      return res.status(404).send("User not found");
    }
    return res.send(user);
  } catch (error) {
    next(error);
  }
};
export default userController;
