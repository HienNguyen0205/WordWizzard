import mongoose from "mongoose";

const topicFolderSchema = new mongoose.Schema({
    folderId: {
      type: mongoose.Types.ObjectId,
      ref: "folders",
    },
    topicId: {
      type: mongoose.Types.ObjectId,
      ref: "topics"
    },
    createdAt: {
      type: Date,
      default: Date.now,
    },
  });

const TopicFolder = mongoose.model("topics_folders", topicFolderSchema);
export default TopicFolder;