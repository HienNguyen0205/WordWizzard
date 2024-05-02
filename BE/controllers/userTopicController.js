import * as userTopicService from "../services/userTopicService.js";
const userTopicController = {};
userTopicController.joinTopic = async (req, res, next) => {
  try {
    if (!req.params.topic_id) {
      return res.status(400).send({
        errorCode: "1",
        message: "Topic id is required.",
      });
    }

    return await userTopicService.joinTopic(req, res);
  } catch (error) {
    next(error);
  }
};

userTopicController.saveTopic = async (req, res, next) => {
  try {
    if (!req.params.topic_id) {
      return res.status(400).send({
        errorCode: "1",
        message: "Topic id is required.",
      });
    }

    return await userTopicService.saveTopic(req, res);
  } catch (error) {
    next(error);
  }
};

userTopicController.joinFlashCard = async (req, res, next) => {
  try {
    if (!req.params.topic_id) {
      return res.status(400).send({
        errorCode: "1",
        message: "Topic id is required.",
      });
    }

    return await userTopicService.joinFlashCard(req, res);
  } catch (error) {
    next(error);
  }
};

userTopicController.resetFlashCard = async (req, res, next) => {
  try {
    if (!req.params.topic_id) {
      return res.status(400).send({
        errorCode: "1",
        message: "Topic id is required.",
      });
    }

    return await userTopicService.resetFlashCard(req, res);
  } catch (error) {
    next(error);
  }
}
export default userTopicController;
