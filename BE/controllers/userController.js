import bcrypt from "bcryptjs";
import UserSchema from "../models/UserSchema.js";
const userController = {};
// def get_hashed_password(password: str) -> str:
//     return pwd_context.hash(password)

// def verify_password(plain_password: str, hashed_password: str) -> bool:
//     return pwd_context.verify(plain_password, hashed_password)

const get_hashed_password = (password) => {
  return bcrypt.hashSync(password, 8);
};
const verify_password = (plain_password, hashed_password) => {
  return bcrypt.compareSync(plain_password, hashed_password);
};

userController.addOne = async (req, res, next) => {
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

userController.getAll = async (req, res, next) => {
  try {
    const { search, page, limit } = req.query;
    let queryObject = {};
    let sortObject = { createdAt: -1 };
    if (search) {
      queryObject.$or = [
        { name: { $regex: `${search}`, $options: "i" } },
        { description: { $regex: `${search}`, $options: "i" } },
      ];
    }

    const pages = Number(page);
    const limits = Number(limit);
    const skip = (pages - 1) * limits;

    const totalDoc = await UserSchema.countDocuments(queryObject);

    const data = await UserSchema.find(queryObject)
      .sort(sortObject)
      .skip(skip)
      .limit(limits);

    return res.send({
      data,
      totalDoc,
      limits,
      pages,
    });
  } catch (err) {
    next(err);
  }
};

export default userController;
