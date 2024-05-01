
import express, { response } from "express";
import topicController from "../controllers/topicController.js";
import authentication from "../middleware/auth.js";
const router = express.Router();

// add topic
router.post('/api/topic/add', authentication, topicController.addOne);

//update topic
router.patch('/api/topic/update/:id', authentication, topicController.updateOne);

// get all topics
router.get('/api/topic/all', authentication, topicController.getAll);

// get topic detail
router.get('/api/topic/detail/:id', authentication, topicController.getOne);

// get all topic client
router.get('/api/topic/all-client', authentication, topicController.getAllClient);
export default router;