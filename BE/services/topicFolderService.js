import Folder from "../models/FolderSchema.js";
import Topic from "../models/TopicSchema.js";
import mongoose from "mongoose";
import TopicFolder from "../models/TopicFolderSchema.js";
const ObjectId = (id) => new mongoose.Types.ObjectId(id);

const updateTopicsToFolder = async (req, res) => {
  const { id } = req.params;
  const topicIds = req.body.topicIds;

  const folder = await Folder.findOne({
    _id: id,
    isDeleted: false,
    createdBy: req.user._id,
  });
  if (!folder) {
    return res.status(404).send({
      errorCode: "2",
      msg: "Folder not found!",
    });
  }
  const topics = await Topic.find({
    _id: { $in: topicIds },
    isDeleted: false,
    createdBy: req.user._id,
  });
  if (topics.length !== topicIds.length) {
    return res.status(404).send({
      errorCode: "3",
      msg: "Some topics not found!",
    });
  }
  const deleteQuery = {
    folderId: id,
    topicId: { $nin: topicIds },
  };
  await TopicFolder.deleteMany(deleteQuery);
  const checkTopicsFolder = await TopicFolder.find({
    topicId: { $in: topicIds },
    folderId: id,
  });
  const newTopicIds = topicIds.filter(
    (topicId) =>
      !checkTopicsFolder.some((folder) => folder.topicId.toString() === topicId)
  );

  if (newTopicIds.length > 0) {
    const topicFolderLinks = newTopicIds.map((topicId) => ({
      topicId: topicId,
      folderId: id,
    }));
    const result = await TopicFolder.insertMany(topicFolderLinks);
    return res.status(200).send({
      msg: "Topics updated to folder successfully!",
      data: result,
    });
  } else {
    return res.status(200).send({
      msg: "Topics updated to folder successfully!",
      data: checkTopicsFolder,
    });
  }
};

const chooseFoldersToAdd = async (req, res) => {
  const { id } = req.params;
  const folderIds = req.body.folderIds;

  const topic = await Topic.findOne({
    _id: id,
    isDeleted: false,
    createdBy: req.user._id,
  });
  if (!topic) {
    return res.status(404).send({
      errorCode: "2",
      msg: "Folder not found!",
    });
  }
  const folders = await Folder.find({
    _id: { $in: folderIds },
    isDeleted: false,
    createdBy: req.user._id,
  });
  if (folders.length !== folderIds.length) {
    return res.status(404).send({
      errorCode: "3",
      msg: "Some folders not found!",
    });
  }
  const deleteQuery = {
    topicId: id,
    folderId: { $nin: folderIds },
  };
  await TopicFolder.deleteMany(deleteQuery);
  const checkTopicsFolder = await TopicFolder.find({
    folderId: { $in: folderIds },
    topicId: id,
  });
  const newFolderIds = folderIds.filter(
    (folderId) =>
      !checkTopicsFolder.some((topic) => topic.folderId.toString() === folderId)
  );

  if (newFolderIds.length > 0) {
    const topicFolderLinks = newFolderIds.map((folderId) => ({
      topicId: id,
      folderId: folderId,
    }));
    const result = await TopicFolder.insertMany(topicFolderLinks);
    return res.status(200).send({
      msg: "Topics updated to folders successfully!",
      data: result,
    });
  } else {
    return res.status(200).send({
      msg: "Topics updated to folders successfully!",
      data: checkTopicsFolder,
    });
  }
};

const getFolders = async (req, res) => {
  const { id } = req.params;
  const folders = await Folder.aggregate([
    {
      $match: {
        createdBy: ObjectId(req.user._id),
        isDeleted: false,
      },
    },
    {
      $lookup: {
        from: "topics_folders",
        localField: "_id",
        foreignField: "folderId",
        as: "topicFolderInfo",
      },
    },
    {
      $project: {
        _id: 1,
        name: 1,
        topicFolderInfo: {
          $filter: {
            input: "$topicFolderInfo",
            as: "topicFolder",
            cond: { $eq: ["$$topicFolder.topicId", ObjectId(id)] },
          },
        },
      },
    },
    {
      $project: {
        _id: 1,
        name: 1,
        isChosen: {
          $cond: {
            if: { $eq: [{ $size: "$topicFolderInfo" }, 0] },
            then: false,
            else: true,
          },
        },
      },
    },
  ]);
  return res.status(200).send({
    msg: "Folders fetched successfully!",
    data: folders,
  });
};

const getTopics = async (req, res) => {
  const { id } = req.params;
  const topics = await Topic.aggregate([
    {
      $match: {
        isDeleted: false,
      },
    },
    {
      $lookup: {
        from: "topics_folders",
        localField: "_id",
        foreignField: "topicId",
        as: "topicFolderInfo",
      },
    },
    {
      $lookup: {
        from: "users",
        localField: "createdBy",
        foreignField: "_id",
        as: "userInfo",
      },
    },
    {
      $lookup: {
        from: "tags",
        localField: "tag",
        foreignField: "_id",
        as: "tagInfo",
      },
    },
    {
      $project: {
        _id: 1,
        name: 1,
        listWords: 1,
        tag: {
          $arrayElemAt: ["$tagInfo", 0],
        },
        topicFolderInfo: {
          $filter: {
            input: "$topicFolderInfo",
            as: "topicFolder",
            cond: { $eq: ["$$topicFolder.folderId", ObjectId(id)] },
          },
        },
        userInfo: {
          $arrayElemAt: ["$userInfo", 0],
        },
      },
    },
    {
      $project: {
        _id: 1,
        name: 1,
        words: {
          $cond: {
            if: { $isArray: "$listWords" }, // Kiểm tra xem listWords có phải là một mảng không
            then: { $size: "$listWords" }, // Nếu là mảng, tính số lượng từ
            else: 0, // Nếu không phải là mảng, gán 0
          },
        },
        tag: {
        name: "$tag.name",
          image: "$tag.image",
        },
        isChosen: {
          $cond: {
            if: { $eq: [{ $size: "$topicFolderInfo" }, 0] },
            then: false,
            else: true,
          },
        },
        createdBy: {
          username: "$userInfo.username",
          image: "$userInfo.image",
        },
      },
    },
  ]);
  return res.status(200).send({
    msg: "Topics fetched successfully!",
    data: topics,
  });
};
export { updateTopicsToFolder, chooseFoldersToAdd, getFolders, getTopics };
