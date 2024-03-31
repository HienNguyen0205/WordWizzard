import mongoose from "mongoose";

const folderSchema = new mongoose.Schema({
  name: {
    type: String,
    trim: true,
    required: true,
  },
  description: {
    type: String,
    trim: true,
    required: false,
  },
  createdBy: {
    type: mongoose.Types.ObjectId,
    ref: "Users",
  },
  isDeleted: {
    type: Boolean,
    default: false,
  },
  createdAt: {
    type: Date,
    default: Date.now,
  },
});



const Folder = mongoose.model("Folders", folderSchema);
export default Folder;