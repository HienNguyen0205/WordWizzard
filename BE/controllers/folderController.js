import Folder from "../models/FolderSchema.js";
import * as folderService from "../services/folderService.js";

const folderController = {};

folderController.addOne = async (req, res, next) => {
  try {
    if (!req.body.name) {
      return res.status(400).send({
        errorCode: "1",
        message: "Name is required.",
      });
    }
    return await folderService.addOne(req, res);
  } catch (error) {
    next(error)
  }
};
folderController.updateOne = async (req, res, next) => {
  try {
    if (!req.params.id) {
      return res.status(400).send({
        errorCode: "1",
        message: "Id is required.",
      });
    }
    return await folderService.updateOne(req, res);
  } catch (error) {
    next(error);
  }
};
folderController.getOne = async (req, res, next) => {
  try {
    if (!req.params.id) {
      return res.status(400).send({
        errorCode: "1",
        message: "Id is required.",
      });
    }
    return await folderService.getOne(req, res);
  } catch (error) {
    next(error)
  }
};

folderController.getAll = async (req, res, next) => {
  try {
    return await folderService.getAll(req, res);
  } catch (error) {
    next(error)
  }
};

export default folderController;
