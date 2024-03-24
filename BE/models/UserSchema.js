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

  createdAt: {
    type: Date,
    default: Date.now,
  },
});
// plugin soft delete
// userSchema.plugin(mongoose_delete, { overrideMethods: true });
// userSchema.pre("save", async function (next) {
//   try {
//     if (!this.code) {
//       this.code = await indexController.getNumber("TTSC");
//     }
//   } catch (error) {
//     console.error("Error:", error);
//   } finally {
//     next();
//   }
// });
const User = mongoose.model("Users", userSchema);

export default User;
