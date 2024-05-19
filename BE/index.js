import express from "express";
import router from "./routes/index.js";
import mongoose from "mongoose";
import cors from "cors";
import dotenv from "dotenv";
import { Tags, Ranks } from "./seed/seed.js";
import { listTags, listRanks } from "./seed/seedData.js";
const app = express();

dotenv.config();
const port = process.env.PORT || 5001;
const dbUrl = process.env.DB_URL;

// Middleware
app.use(express.urlencoded({ extended: true }));
app.use(express.json());
app.use(express.static("./public"));
app.use(router);
app.use(
  cors({
    methods: ["GET", "POST", "PUT", "DELETE"],
  })
);

mongoose
  .connect(dbUrl)
  .then(async () => {
    const rankCount = await Ranks.countDocuments();
    const tagsCount = await Tags.countDocuments();
    if (tagsCount === 0) {
      await Tags.insertMany(listTags);
    }
    if (rankCount === 0) {
      await Ranks.insertMany(listRanks);
    }
    console.log("MongoDB connected and seed successfully");
  })
  .catch((err) => console.error("Failed to connect to MongoDB", err));

app.listen(port, () => {
  console.log(`Example app listening at http://localhost:${port}`);
});
