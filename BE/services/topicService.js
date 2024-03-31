import Topic from "../models/TopicSchema.js";
import mongoose from "mongoose";
const ObjectId = (id) => new mongoose.Types.ObjectId(id);

const addOne = async (req, res) => {
  if (
    (req?.body?.securityView === "HASKEY" ||
      req?.body?.securityEdit === "HASKEY") &&
    !req?.body?.key
  ) {
    return res.status(400).send({
      errorCode: "6",
      message: "Key is required for HASKEY security.",
    });
  }
  const listWords = req.body.listWords.map((word) => {
    return {
      general: word.general,
      meaning: word.meaning,
    };
  });
  const topic = new Topic({
    name: req.body.name,
    description: req.body.description,
    securityView: req.body.securityView,
    securityEdit: req.body.securityEdit,
    generalType: req.body.generalType,
    meaningType: req.body.meaningType,
    listWords: listWords,
    key: req.body.key,
    createdBy: req.user._id,
  });
  await topic.save();
  const response_data = {
    _id: topic._id,
    name: topic.name,
    description: topic.description,
    securityView: topic.securityView,
    securityEdit: topic.securityEdit,
    generalType: topic.generalType,
    meaningType: topic.meaningType,
    listWords: topic.listWords,
    createdBy: topic.createdBy,
    createdAt: topic.createdAt,
  };
  return res.status(201).send({
    msg: "Topic created successfully!",
    data: response_data,
  });
};

const getAll = async (req, res) => {
  const userId = req.user._id;
  const { search, page, limit } = req.query;

  let queryObject = {};
  if (search) {
    queryObject.$or = [{ name: { $regex: `${search}`, $options: "i" } }];
  }
  const pages = Number(page);
  const limits = Number(limit);
  const skip = (pages - 1) * limits;
  const folders = await Topic.aggregate([
    {
      $match: {
        createdBy: ObjectId(userId),
        isDeleted: false,
        ...queryObject,
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
      $unwind: "$user",
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
        createdBy: {
          $first: {
            _id: "$user._id",
            username: "$user.username",
          },
        },
        createdAt: {
          $first: "$createdAt",
        },
        words: {
          $sum: {
            $size: "$listWords",
          },
        },
      },
    },
    {
      $skip: skip,
    },
    {
      $limit: limits,
    },
    {
      $sort: {
        createdAt: -1,
      },
    },
  ]);
  return res.status(200).send({
    msg: "Folders fetched successfully!",
    data: folders,
  });
};

const getOne = async (req, res) => {
  const { id } = req.params;
  const topic = await Topic.aggregate([
    {
      $match: {
        _id: ObjectId(id),
        createdBy: ObjectId(req.user._id),
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
        securityEdit: {
          $first: "$securityEdit",
        },
        generalType: {
          $first: "$generalType",
        },
        meaningType: {
          $first: "$meaningType",
        },
        createdBy: {
          $first: {
            _id: "$user._id",
            username: "$user.username",
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
  return res.status(200).send({
    msg: "Topic fetched successfully!",
    data: topic,
  });
};
export { addOne, getOne, getAll };
