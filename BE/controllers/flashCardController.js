import * as flashCardService from "../services/flashCardService.js";
const flashCardController = {};
flashCardController.joinFlashCard = async (req, res, next) => {
  try {
    if (!req.params.topic_id) {
      return res.status(400).send({
        errorCode: "1",
        message: "Topic id is required.",
      });
    }

    return await flashCardService.joinFlashCard(req, res);
  } catch (error) {
    next(error);
  }
};
export default flashCardController;
