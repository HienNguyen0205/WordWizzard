import Topic from "../models/TopicSchema.js";
import * as topicService from "../services/topicService.js";

const topicController = {};

topicController.addOne = async (req, res) => {
  try {
    if (!req.body.name) {
      return res.status(400).send({
        errorCode: "1",
        message: "Name is required.",
      });
    } else if (!req.body.generalType) {
      return res.status(400).send({
        errorCode: "2",
        message: "General Type is required.",
      });
    } else if (!req.body.meaningType) {
      return res.status(400).send({
        errorCode: "3",
        message: "Meaning Type is required.",
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
      return await topicService.addOne(req, res);
    }
  } catch (error) {
    res.status(400).send(error);
  }
};

topicController.getAll = async (req, res) => {
  try {
    return await topicService.getAll(req, res);
  } catch (error) {
    res.status(400).send(error);
  }
};

topicController.getOne = async (req, res) => {
  try {
    if (!req.params.id) {
      return res.status(400).send({
        errorCode: "1",
        message: "Id is required.",
      });
    }
    return await topicService.getOne(req, res);
  } catch (error) {
    res.status(400).send(error);
  }
}
export default topicController;
