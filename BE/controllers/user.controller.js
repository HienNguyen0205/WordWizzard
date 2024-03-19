import mongoose from "mongoose";
import UserSchema from "../schemas/UserSchema.js";

const User = mongoose.model('users', UserSchema);

export async function getAllUsers(req, res) {
    try {
        const users = await User.find({});
        res.json(users);
    } catch (err) {
        res.send(err);
    }
}

