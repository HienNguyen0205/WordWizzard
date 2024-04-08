import Topic from "../models/TopicSchema.js";
import * as topicService from "../services/topicService.js";

const topicController = {};

topicController.addOne = async (req, res, next) => {
  try {
    if (req.body.name || JSON.parse(req.body.listWords).length !== 0) {
      return await topicService.addOne(req, res);
    }
    else {
      return res.status(200).send({
        msg: "Success",
        data: {},
      });
    }
  } catch (error) {
    next(error);
  }
};

topicController.updateOne = async (req, res, next) => {
  try {
    if (req.body.name || JSON.parse(req.body.listWords).length !== 0) {
      return await topicService.updateOne(req, res);
    }
    else {
      
      return await topicService.deleteDraft(req, res);
    }
  } catch (error) {
    next(error);
  }
};
topicController.getAll = async (req, res, next) => {
  try {
    return await topicService.getAll(req, res);
  } catch (error) {
    next(error);
  }
};

topicController.getOne = async (req, res, next) => {
  try {
    if (!req.params.id) {
      return res.status(400).send({
        errorCode: "1",
        message: "Id is required.",
      });
    }
    return await topicService.getOne(req, res);
  } catch (error) {
    next(error);
  }
};

topicController.getAllClient = async (req, res, next) => {
  try {
    return await topicService.getAllClient(req, res);
  } catch (error) {
    next(error);
  }
};
export default topicController;
