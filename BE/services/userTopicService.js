import UserTopic from "../models/UserTopicSchema.js";
import Topic from "../models/TopicSchema.js";
import mongoose from "mongoose";
import { response } from "express";
import { update_points_user } from "./userService.js";
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
            _id: "$topic_tag._id",
            name: "$topic_tag.name",
            value: "$topic_tag.value",
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
    topic[0].listWords = topic[0].listWords.map((word) => {
      return {
        ...word,
        is_mark: user_topic?.words_mark?.includes(word._id),
      };
    });
    return res.status(200).send({
      message: "Join quiz successfully.",
      data: topic[0],
    });
  } else {
    const new_user_topic = new UserTopic({
      user_id,
      topic_id: topicId,
    });

    await new_user_topic.save();
    topic[0].listWords = topic[0].listWords.map((word) => {
      return {
        ...word,
        is_mark: false,
      };
    });
    return res.status(200).send({
      message: "Join quiz successfully.",
      data: topic[0],
    });
  }
};

const saveTopic = async (req, res) => {
  const { topic_id } = req.params;
  const words_mark = JSON.parse(req.body.words_mark);
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
  return res.status(200).send({
    message: "Save word marks successfully.",
  });
};

const finishTopicQuiz = async (req, res) => {
  const { topic_id } = req.params;
  const { word_length, correct_percent } = req.body;
  const { _id: user_id } = req.user;
  const point_earn = (50 * correct_percent * word_length) / 100;
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
  await update_points_user(user_id, point_earn);
  return res.status(200).send({
    message: "Finish quiz successfully.",
    data: {
      point_earn: point_earn,
    },
  });
};

const getPopularTopics = async (req, res) => {
  const { search, page, limit } = req.query;
  let queryObject = {};
  if (search) {
    queryObject.$or = [{ name: { $regex: `${search}`, $options: "i" } }];
  }
  const pages = Number(page);
  const limits = Number(limit);
  const skip = (pages - 1) * limits;

  const topics = await UserTopic.aggregate([
    {
      $lookup: {
        from: "topics",
        localField: "topic_id",
        foreignField: "_id",
        as: "topic",
      },
    },
    { $unwind: "$topic" },
    {
      $match: {
        "topic.isDeleted": false,
        "topic.securityView": "PUBLIC",
        ...queryObject,
      },
    },
    {
      $group: {
        _id: "$topic_id",
        name: { $first: "$topic.name" },
        description: { $first: "$topic.description" },
        securityView: { $first: "$topic.securityView" },
        tag: { $first: "$topic.tag" },
        createdBy: { $first: "$topic.createdBy" },
        createdAt: { $first: "$topic.createdAt" },
        words: { $first: { $size: "$topic.listWords" } },
        count: { $sum: 1 },
      },
    },
    { $sort: { count: -1 } },
    { $skip: skip },
    { $limit: limits },
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
    { $unwind: "$user" },
    { $unwind: "$topic_tag" },
    {
      $project: {
        _id: 1,
        name: 1,
        description: 1,
        securityView: 1,
        tag: {
          _id: "$topic_tag._id",
          name: "$topic_tag.name",
          value: "$topic_tag.value",
          image: "$topic_tag.image",
        },
        createdBy: {
          _id: "$user._id",
          username: "$user.username",
          image: "$user.image",
        },
        createdAt: 1,
        words: 1,
        count: 1,
      },
    },
  ]);
  for (let i = 0; i < 10; i++) {
    if (i < topics.length) {
      topics[i].ranking = i + 1;
    }
    else {
      break;
    }
  }
  return res.status(200).send({
    message: "Get popular topics successfully.",
    data: topics,
  });
};
export { joinTopic, saveTopic, finishTopicQuiz, getPopularTopics };
