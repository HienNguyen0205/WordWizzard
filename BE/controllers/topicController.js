import Topic from "../models/TopicSchema.js";
import * as topicService from "../services/topicService.js";

const topicController = {};

topicController.addOne = async (req, res, next) => {
  try {
    if (!req.body.name) {
      return res.status(400).send({
        errorCode: "1",
        message: "Name is required.",
      });
    } else if (!req.body.tag) {
      return res.status(400).send({
        errorCode: "2",
        message: "Tag is required.",
      });
    } else if (!req.body.listWords) {
      return res.status(400).send({
        errorCode: "3",
        message: "List Words is required.",
      });
    } else if (req.body.listWords.length < 2) {
      return res.status(400).send({
        errorCode: "4",
        message: "List Words must have at least 2 words.",
      });
    } else {
      return await topicService.addOne(req, res);
    }
  } catch (error) {
    next(error);
  }
};

topicController.updateOne = async (req, res, next) => {
  try {
    if (!req.params.id) {
      return res.status(400).send({
        errorCode: "1",
        message: "Id is required.",
      });
    } else if (!req.body.name) {
      return res.status(400).send({
        errorCode: "2",
        message: "Name is required.",
      });
    } else if (!req.body.tag) {
      return res.status(400).send({
        errorCode: "3",
        message: "Tag is required.",
      });
    } else if (!req.body.listWords) {
      return res.status(400).send({
        errorCode: "4",
        message: "List Words is required.",
      });
    } else if (req.body.listWords.length < 2) {
      return res.status(400).send({
        errorCode: "5",
        message: "List Words must have at least 2 words.",
      });
    } else {
      return await topicService.updateOne(req, res);
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
export default topicController;
