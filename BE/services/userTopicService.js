import UserTopic from "../models/UserTopicSchema.js";
import Topic from "../models/TopicSchema.js";
import mongoose from "mongoose";
import { response } from "express";
const ObjectId = (id) => new mongoose.Types.ObjectId(id);

const joinTopic = async (req, res) => {
  const { topic_id } = req.params;
  const { _id: user_id } = req.user;
  const topicId = ObjectId(topic_id);
  const topic = await Topic.aggregate([
    {
      $match: {
        _id: topicId,
        isDeleted: false,
      },
    },
    {
      $lookup: {
        from: "users",
        localField: "createdBy",
        foreignField: "_id",
        as: "user",
      },
    },
    {
      $lookup: {
        from: "tags",
        localField: "tag",
        foreignField: "_id",
        as: "topic_tag",
      },
    },
    {
      $unwind: "$user",
    },
    {
      $unwind: "$topic_tag",
    },
    {
      $group: {
        _id: "$_id",
        name: {
          $first: "$name",
        },
        description: {
          $first: "$description",
        },
        securityView: {
          $first: "$securityView",
        },
        tag: {
          $first: {
            name: "$topic_tag.name",
            image: "$topic_tag.image",
          },
        },
        createdBy: {
          $first: {
            _id: "$user._id",
            username: "$user.username",
            image: "$user.image",
          },
        },
        createdAt: {
          $first: "$createdAt",
        },
        listWords: {
          $first: "$listWords",
        },
      },
    },
    
  ]);

  const user_topic = await UserTopic.findOne({
    user_id,
    topic_id: topicId,
  });

  if (user_topic) {
    topic[0].listWords = topic[0].listWords.map(word => {
      return {
        ...word,
        is_mark: user_topic?.words_mark?.includes(word._id)
      };
    });
    return res.status(200).send({
      message: "Join flash card successfully.",
      data: topic[0],
    });
  } else {
    const new_user_topic = new UserTopic({
      user_id,
      topic_id: topicId,
    });
    await new_user_topic.save();
    return res.status(200).send({
      message: "Join flash card successfully.",
      data: topic[0],
    });
  }
};

const saveTopic = async (req, res) => {
  const { topic_id } = req.params;
  const { words_mark, words_studying, words_learned  } = req.body;
  const { _id: user_id } = req.user;
  const topicId = ObjectId(topic_id);

  const user_topic = await UserTopic.findOne({
    user_id,
    topic_id: topicId,
  });

  if (!user_topic) {
    return res.status(400).send({
      message: "User topic not found.",
    });
  }
  if (words_mark) {
    user_topic.words_mark = words_mark;
    await user_topic.save();
  }
  if (words_studying) {
    user_topic.words_studying = words_studying;
    await user_topic.save();
  }
  if (words_learned) {
    user_topic.words_learned = words_learned;
    await user_topic.save();
  }
  return res.status(200).send({
    message: "Save word marks successfully.",
  });
};

const joinFlashCard = async (req, res) => {
  const { topic_id }  = req.params;
  const { is_mark, is_shuffle } = req.query;
  const { _id: user_id } = req.user;
  const topicId = ObjectId(topic_id);
  const topic = await Topic.findById(topicId);
  
  const user_topic = await UserTopic.findOne({
    user_id,
    topic_id: topicId,
  });
  let current_index = user_topic.words_studying.length + user_topic.words_learned.length + 1;
  let list_words = topic.listWords.slice(current_index - 1);
  if (is_mark == 1) {
    list_words = list_words.filter(word => user_topic.words_mark.includes(word._id));
  }
  if (is_shuffle == 1) {
    list_words = list_words.sort(() => Math.random() - 0.5);
  }
  const response_data = {
    list_words: list_words,
    count_studying: user_topic.words_studying.length,
    count_learned: user_topic.words_learned.length,
    current_index: user_topic.words_studying.length + user_topic.words_learned.length + 1,
  };
  return res.status(200).send({
    message: "Join flash card successfully.",
    data: response_data,
  });
}

const resetFlashCard = async (req, res) => {
  const { topic_id } = req.params;
  const { _id: user_id } = req.user;
  const topicId = ObjectId(topic_id);
  const user_topic = await UserTopic.findOne({
    user_id,
    topic_id: topicId,
  });
  user_topic.words_studying = [];
  user_topic.words_learned = [];
  await user_topic.save();
  return res.status(200).send({
    message: "Reset flash card successfully.",
  });
}

export { joinTopic, saveTopic, joinFlashCard, resetFlashCard };
