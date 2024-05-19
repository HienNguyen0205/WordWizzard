import mongoose from "mongoose";

const userTopicSchema = new mongoose.Schema({
  user_id: {
    type: mongoose.Types.ObjectId,
    trim: true,
    required: true,
  },
  topic_id: {
    type: mongoose.Types.ObjectId,
    trim: true,
    required: true,
  },
  words_mark: {
    type: [mongoose.Types.ObjectId],
    default: [],
  },
  user_scores: {
    type: Number,
    default: 0,
  },
  createdAt: {
    type: Date,
    default: Date.now,
  },
});



const UserTopic = mongoose.model("user_topic", userTopicSchema);
export default UserTopic;