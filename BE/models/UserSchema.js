import mongoose from "mongoose";
import mongoose_delete from "mongoose-delete";
import bcrypt from "bcryptjs";
const userSchema = new mongoose.Schema({
  username: {
    type: String,
    trim: true,
    required: true,
  },
  email: {
    type: String,
    required: [true, "Email is required"],
    match: [
      /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/,
      "Email format is not correct",
    ],
    lowercase: true,
    unique: true,
  },
  password: {
    type: String,
    required: true,
    default: bcrypt.hashSync("12345678"),
  },
  fullname: {
    type: String,
    trim: true,
    required: false,
    default: "",
  },
  phone: {
    type: String,
    trim: true,
    required: false,
    default: "",
  },
  image: {
    type: String,
    required: false,
    default: "",
  },
  level: {
    type: Number,
    default: 1,
    required: false,
  },
  points: {
    type: Number,
    default: 0,
    required: false,
  },
  createdAt: {
    type: Date,
    default: Date.now,
  },
});
const User = mongoose.model("Users", userSchema);

export default User;
