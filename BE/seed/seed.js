import mongoose from "mongoose";
import dotenv from "dotenv";
dotenv.config();
const dbUrl = process.env.DB_URL;

const tagsSchema = new mongoose.Schema({
  name: {
    type: String,
    trim: true,
  },
  value: {
    type: String,
    trim: true,
  },
  image: {
    type: String,
    trim: true,
  },
});

const Tags = new mongoose.model("Tags", tagsSchema);

const ranksSchema = new mongoose.Schema({
  name: {
    type: String,
    trim: true,
  },
  value: {
    type: Number,
    trim: true,
  },
  tag: {
    type: String,
    trim: true,
  },
});

const Ranks = new mongoose.model("Ranks", ranksSchema);
export { Tags, Ranks };
