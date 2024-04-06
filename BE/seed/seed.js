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

export default Tags
