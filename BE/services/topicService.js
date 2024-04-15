import Topic from "../models/TopicSchema.js";
import mongoose from "mongoose";
import Tags from "../seed/seed.js";
import topicController from "../controllers/topicController.js";
const ObjectId = (id) => new mongoose.Types.ObjectId(id);

const checkListWordsEmpty = (listWords) => {
  if (listWords.every((word) => !word.general && !word.meaning)) {
    return true;
  } else {
    return false;
  }
};

const addOne = async (req, res) => {
  let listWords = [];
  if (JSON.parse(req.body.listWords).length !== 0) {
    listWords = JSON.parse(req.body.listWords).map((word) => {
      return {
        general: word.general,
        meaning: word.meaning,
      };
    });
  }
  if (checkListWordsEmpty(listWords) && !req.body.name) {
    return res.status(200).send({
      msg: "Nothing to create",
      data: [],
    });
  } else {
    const tag = await Tags.findOne({ value: req.body.tag });
    if (!tag) {
      return res.status(400).send({
        errorCode: "6",
        message: "Tag not found",
      });
    }
    const topic = new Topic({
      name: req.body.name,
      description: req.body.description,
      securityView: req.body.securityView,
      listWords: listWords,
      tag: tag._id,
      createdBy: req.user._id,
    });
    await topic.save();
    const response_data = {
      _id: topic._id,
      name: topic.name,
      description: topic.description,
      securityView: topic.securityView,
      listWords: topic.listWords,
      tag: {
        tag_name: tag.name,
        tag_image: tag.image,
      },
      createdBy: topic.createdBy,
      createdAt: topic.createdAt,
    };
    return res.status(201).send({
      msg: "Topic created successfully!",
      data: response_data,
    });
  }
};

const updateOne = async (req, res) => {
  const listWords = JSON.parse(req.body.listWords).map((word) => {
    return {
      general: word.general,
      meaning: word.meaning,
    };
  });
  const { id } = req.params;
  if (checkListWordsEmpty(listWords) && !req.body.name) {
    const topic = await Topic.deleteOne({ _id: id });
    return res.status(200).send({
      msg: "Topic Draft deleted successfully!",
      data: topic,
    });
  } else {
    const tag = await Tags.findOne({ value: req.body.tag });
    if (!tag) {
      return res.status(400).send({
        errorCode: "6",
        message: "Tag not found",
      });
    }
    const topic = await Topic.findById(id);

    topic.name = req.body.name;
    topic.description = req.body.description;
    topic.securityView = req.body.securityView;
    topic.listWords = listWords;
    topic.tag = tag._id;
    await topic.save();
    const response_data = {
      _id: topic._id,
      name: topic.name,
      description: topic.description,
      securityView: topic.securityView,
      listWords: topic.listWords,
      tag: {
        tag_name: tag.name,
        tag_image: tag.image,
      },
      createdBy: topic.createdBy,
      createdAt: topic.createdAt,
    };
    return res.status(201).send({
      msg: "Topic updated successfully!",
      data: response_data,
    });
  }
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
  const topics = await Topic.aggregate([
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
      $lookup: {
        from: "tags",
        localField: "tag",
        foreignField: "_id",
        as: "topic_tag",
      },
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
        words: {
          $sum: {
            $size: "$listWords",
          },
        },
      },
    },
    {
      $sort: {
        createdAt: -1,
      },
    },
    {
      $skip: skip,
    },
    {
      $limit: limits,
    },
  ]);
  return res.status(200).send({
    msg: "Topic fetched successfully!",
    data: topics,
  });
};

const getOne = async (req, res) => {
  const { id } = req.params;
  const check_topic = await Topic.findById(id);
  if (!check_topic) {
    return res.status(404).send({
      errorCode: "2",
      message: "Topic not found",
    });
  }
  const topic = await Topic.aggregate([
    {
      $match: {
        _id: ObjectId(id),
        // createdBy: ObjectId(req.user._id),
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
  return res.status(200).send({
    msg: "Topic fetched successfully!",
    data: topic,
  });
};

const getAllClient = async (req, res) => {
  const userId = req.user.id;
  const { search, page, limit } = req.query;

  let queryObject = {};
  if (search) {
    queryObject.$or = [{ name: { $regex: `${search}`, $options: "i" } }];
  }
  const pages = Number(page);
  const limits = Number(limit);
  const skip = (pages - 1) * limits;
  const topics = await Topic.aggregate([
    {
      $match: {
        securityView: "PUBLIC",
        createdBy: { $ne: ObjectId(userId) },
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
      $lookup: {
        from: "tags",
        localField: "tag",
        foreignField: "_id",
        as: "topic_tag",
      },
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
            username: "$user.username",
            image: "$user.image",
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
      $sort: {
        createdAt: -1,
      },
    },
    {
      $skip: skip,
    },
    {
      $limit: limits,
    },
  ]);
  return res.status(200).send({
    msg: "Topic fetched successfully!",
    data: topics,
  });
};
// const deleteDraft = async (req, res) => {
//   const { id } = req.params;
//   const topic = await Topic.deleteOne({ _id: id });
//   return res.status(200).send({
//     msg: "Topic Draft deleted successfully!",
//     data: topic,
//   });
// };
export { addOne, getOne, getAll, updateOne, getAllClient };
