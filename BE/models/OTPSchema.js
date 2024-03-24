import mongoose from "mongoose";
import mongoose_delete from "mongoose-delete";
const otpSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "Users",
    required: true,
  },
  otp: {
    type: String,
    required: true,
  },
  expiresAt: {
    type: Date,
    expires: 0,
  },
});

const OTP = mongoose.model("otp_users", otpSchema);

export default OTP;
