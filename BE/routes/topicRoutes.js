
import express, { response } from "express";
import topicController from "../controllers/topicController.js";
import authentication from "../middleware/auth.js";
const router = express.Router();

// add topic
router.post('/api/topic/add', authentication, topicController.addOne);

// get all topics
router.get('/api/topic/all', authentication, topicController.getAll);

// get topic detail
router.get('/api/topic/detail/:id', authentication, topicController.getOne);
export default router;