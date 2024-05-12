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
  const { _id: user_id } = req.user;
  const point_earn = 100;
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

export { joinTopic, saveTopic, finishTopicQuiz };
