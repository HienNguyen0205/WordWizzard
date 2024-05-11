import Folder from "../models/FolderSchema.js";
import Topic from "../models/TopicSchema.js";
import mongoose from "mongoose";
const ObjectId = (id) => new mongoose.Types.ObjectId(id);
const addOne = async (req, res) => {
  const folder = new Folder({
    name: req.body.name,
    description: req.body.description,
    createdBy: req.user._id,
  });
  await folder.save();
  const response_data = {
    _id: folder._id,
    name: folder.name,
    description: folder.description,
    createdBy: folder.createdBy,
  };
  return res.status(201).send({
    msg: "Folder created successfully!",
    data: response_data,
  });
};
// const getOne = async (req, res) => {
//   const { id } = req.params;
//   const folder = await Folder().findById(id).populate("createdBy");
//   if (!folder) {
//     return res.status(404).send({
//       msg: "Folder not found!",
//     });
//   }
//   return res.status(200).send({
//     msg: "Folder fetched successfully!",
//     data: folder,
//   });
// };

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
  const folders = await Folder.aggregate([
    {
      $match: {
        createdBy: ObjectId(userId),
        isDeleted: false,
        ...queryObject,
      },
    },
    {
      $lookup: {
        from: "topics_folders",
        localField: "_id",
        foreignField: "folderId",
        as: "listTopics",
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
            image: "$user.image",
          },
        },
        createdAt: {
          $first: "$createdAt",
        },
        listTopics: {
          $sum: { $size: "$listTopics" },
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
    msg: "Folders fetched successfully!",
    data: folders,
  });
};

const getOne = async (req, res) => {
  const { id } = req.params;
  const check_folder = await Folder.findById(id);
  if (!check_folder) {
    return res.status(404).send({
      errorCode: "2",
      message: "Folder not found",
    });
  }
  const folder = await Folder.aggregate([
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
      $lookup: {
        from: "topics_folders",
        let: { folderId: "$_id" },
        pipeline: [
          {
            $match: {
              $expr: {
                $eq: ["$folderId", "$$folderId"],
              },
            },
          },
          {
            $lookup: {
              from: "topics",
              localField: "topicId",
              foreignField: "_id",
              as: "topicDetails",
            },
          },
          {
            $match: {
              "topicDetails.isDeleted": false,
            },
          },
          {
            $lookup: {
              from: "tags",
              localField: "topicDetails.tag",
              foreignField: "_id",
              as: "tagDetails",
            },
          },
          {
            $lookup: {
              from: "users",
              localField: "topicDetails.createdBy",
              foreignField: "_id",
              as: "userDetails",
            },
          },
          {
            $unwind: "$topicDetails",
          },
          {
            $unwind: "$tagDetails",
          },
          {
            $unwind: "$userDetails",
          },
          {
            $project: {
              _id: "$topicDetails._id",
              name: "$topicDetails.name",
              description: "$topicDetails.description",
              securityView: "$topicDetails.securityView",
              tag: {
                name: "$tagDetails.name",
                image: "$tagDetails.image",
              },
              createdBy: {
                username: "$userDetails.username",
                image: "$userDetails.image",
              },
              listWordsSize: { $size: "$topicDetails.listWords" },
            },
          },
        ],
        as: "listTopicsInfo",
      },
    },
    {
      $unwind: "$user",
    },
    {
      $addFields: {
        listTopics: {
          $map: {
            input: "$listTopicsInfo",
            as: "topic",
            in: {
              _id: "$$topic._id",
              name: "$$topic.name",
              description: "$$topic.description",
              securityView: "$$topic.securityView",
              tag: "$$topic.tag",
              createdBy: "$$topic.createdBy",
              words: "$$topic.listWordsSize",
            },
          },
        },
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
        listTopics: {
          $first: "$listTopics",
        },
      },
    },
  ]);
  return res.status(200).send({
    msg: "Folder fetched successfully!",
    data: folder[0],
  });
};

const updateOne = async (req, res) => {
  const { id } = req.params;
  const folder = await Folder.findById(id);
  if (!folder) {
    return res.status(404).send({
      msg: "Folder not found!",
    });
  }
  if (!req.body.name) {
    return res.status(400).send({
      msg: "Name is required!",
    });
  }
  folder.name = req.body.name;
  folder.description = req.body.description;
  await folder.save();
  return res.status(200).send({
    msg: "Folder updated successfully!",
    data: folder,
  });
};

const deleteOne = async (req, res) => {
  const { id } = req.params;
  const folder = await Folder.findById({ _id: id });
  if (!folder) {
    return res.status(404).send({
      msg: "Folder not found!",
    });
  }
  folder.isDeleted = true;
  await folder.save();
  return res.status(200).send({
    msg: "Folder deleted successfully!",
  });
};
export { addOne, getAll, getOne, updateOne, deleteOne };
