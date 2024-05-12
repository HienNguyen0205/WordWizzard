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

userTopicController.finishTopicQuiz = async (req, res, next) => {
  try {
    if (!req.params.topic_id) {
      return res.status(400).send({
        errorCode: "1",
        message: "Topic id is required.",
      });
    }
    return await userTopicService.finishTopicQuiz(req, res);
  } catch (error) {
    next(error);
  }
}

userTopicController.getPopularTopics = async (req, res, next) => {
  try {
    return await userTopicService.getPopularTopics(req, res);
  } catch (error) {
    next(error);
  }
}
export default userTopicController;
