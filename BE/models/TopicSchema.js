import mongoose from "mongoose";

const topicSchema = new mongoose.Schema({
  name: {
    type: String,
    trim: true,
    required: false,
  },
  description: {
    type: String,
    trim: true,
    required: false,
  },
  securityView: {
    type: String,
    enum: ["PUBLIC", "DRAFT", "PRIVATE"],
    default: "PUBLIC",
  },
  listWords: [
    {
      general: {
        type: String,
        trim: true,
        required: true,
      },
      meaning: {
        type: String,
        trim: true,
        required: true,
      },
    },
  ],
  tag: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "Tags",
    require: true
  },
  createdBy: {
    type: mongoose.Schema.Types.ObjectId,
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

const Topic = mongoose.model("Topics", topicSchema);
export default Topic;
