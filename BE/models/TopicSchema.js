import mongoose from "mongoose";

const topicSchema = new mongoose.Schema({
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
  securityView: {
    type: String,
    enum: ["PUBLIC", "HASKEY", "PRIVATE"],
    default: "PUBLIC",
  },
  securityEdit: {
    type: String,
    enum: ["HASKEY", "PRIVATE"],
    default: "PRIVATE",
  },
  generalType: {
    type: String,
    trim: true,
    required: true,
  },
  meaningType: {
    type: String,
    trim: true,
    required: true,
  },
  key: {
    type: String,
    trim: true,
    required: false,
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
