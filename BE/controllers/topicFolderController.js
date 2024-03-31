import TopicFolder from "../models/TopicFolderSchema.js";
import * as topicFolderService from "../services/topicFolderService.js";

const topicFolderController = {};

topicFolderController.addOne = async (req, res, next) => {
  try {
    if (!req.body.name) {
      return res.status(400).send({
        errorCode: "1",
        message: "Name is required.",
      });
    }
    return await topicFolderController.addOne(req, res);
  } catch (error) {
    next(error);
  }
};
topicFolderController.updateTopicsToFolder = async (req, res, next) => {
  try {
    if (!req.body.topicIds) {
      return res.status(400).send({
        errorCode: "1",
        message: "Topics are required.",
      });
    }
    if (!req.params.id) {
      return res.status(400).send({
        errorCode: "2",
        message: "Id is required.",
      });
    }
    return await topicFolderService.updateTopicsToFolder(req, res);
  } catch (error) {
    next(error);
  }
};

topicFolderController.chooseFoldersToAdd = async (req, res, next) => {
  try {
    if (!req.body.folderIds) {
      return res.status(400).send({
        errorCode: "1",
        message: "Folders are required.",
      });
    }
    if (!req.params.id) {
      return res.status(400).send({
        errorCode: "2",
        message: "Id is required.",
      });
    }
    return await topicFolderService.chooseFoldersToAdd(req, res);
  } catch (error) {
    next(error);
  }
};

topicFolderController.getFolders = async (req, res, next) => {
  try {
    if (!req.params.id) {
      return res.status(400).send({
        errorCode: "1",
        message: "Id is required.",
      });
    }
    return await topicFolderService.getFolders(req, res);
  } catch (error) {
    next(error);
  }
};

topicFolderController.getTopics = async (req, res, next) => {
  try {
    if (!req.params.id) {
      return res.status(400).send({
        errorCode: "1",
        message: "Id is required.",
      });
    }
    return await topicFolderService.getTopics(req, res);
  } catch (error) {
    next(error);
  }
};
// topicFolderController.getAll = async (req, res) => {
//   try {
//     return await topicSevice.getAll(req, res);
//   } catch (error) {
//     next(error)
//   }
// };
export default topicFolderController;
