import mongoose from "mongoose";

const flashCardSchema = new mongoose.Schema({
  player_id: {
    type: mongoose.Types.ObjectId,
    trim: true,
    required: true,
  },
  topic_id: {
    type: mongoose.Types.ObjectId,
    trim: true,
    required: true,
  },
  listWords: [
    {
      general: {
        type: String,
        trim: true,
        required: false,
      },
      meaning: {
        type: String,
        trim: true,
        required: false,
      },
      status: {
        type: Number,
        default: 0,
        enum: [0, 1, 2],
        required: false,
        // 0: not study, 1: is studying, 2: studied 
      },
    },
  ],
  status: {
    type: Number,
    default: 0,
    enum: [0, 1]
    // 0: in progress, 1: completed
  },
  createdAt: {
    type: Date,
    default: Date.now,
  },
});



const FlashCard = mongoose.model("FlashCard", flashCardSchema);
export default FlashCard;