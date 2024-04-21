import FlashCard from "../models/FlashCardSchema.js";
import Topic from "../models/TopicSchema.js";
import mongoose from "mongoose";
const ObjectId = (id) => new mongoose.Types.ObjectId(id);

const joinFlashCard = async (req, res) => {
  const { topic_id } = req.params;
  const { _id: player_id } = req.user;
  const topicId = ObjectId(topic_id);
  const topic = await Topic.findById(topicId);

  const flashCard = await FlashCard.findOne({
    player_id,
    topic_id: topicId,
  });

  if (flashCard) {
    const indexWord = flashCard.listWords.filter(
      (word) => word.status !== 0
    ).length;
    const currentListWords = flashCard.listWords.filter(
      (word) => word.status === 0
    );
    const isStudying = flashCard.listWords.filter(
      (word) => word.status === 1
    ).length;
    const isFinish = flashCard.listWords.filter(
      (word) => word.status === 2
    ).length;
    const response_data = {
      listWords: currentListWords,
      lengthListWords: flashCard.listWords.length,
      indexWord: indexWord,
      isStudying: isStudying,
      isFinish: isFinish,
    };
    return res.status(200).send({
      message: "Join flash card successfully.",
      data: response_data,
    });
  } else {
    const newFlashCard = new FlashCard({
      player_id,
      topic_id: topicId,
      listWords: topic.listWords,
    });
    await newFlashCard.save();
    const response_data = {
      listWords: topic.listWords,
      lengthListWords: topic.listWords.length,
      indexWord: 0,
      isStudying: 0,
      isFinish: 0,
    };
    return res.status(200).send({
      message: "Join flash card successfully.",
      data: response_data,
    });
  }
};
export { joinFlashCard };
