import Folder from "../models/FolderSchema.js";
import * as folderService from "../services/folderService.js";

const folderController = {};

folderController.addOne = async (req, res) => {
  try {
    if (!req.body.name) {
      return res.status(400).send({
        errorCode: "1",
        message: "Name is required.",
      });
    }
    return await folderService.addOne(req, res);
  } catch (error) {
    res.status(400).send(error);
  }
};

folderController.getOne = async (req, res) => {
  try {
    if (!req.params.id) {
      return res.status(400).send({
        errorCode: "1",
        message: "Id is required.",
      });
    }
    return await folderService.getOne(req, res);
  } catch (error) {
    res.status(400).send(error);
  }
};

folderController.getAll = async (req, res) => {
  try {
    return await folderService.getAll(req, res);
  } catch (error) {
    res.status(400).send(error);
  }
};


export default folderController;
