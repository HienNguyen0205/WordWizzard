import express from 'express'
import userRouter from './user.routes.js';
const router = express.Router()

/**
 * @openapi
 * /ping:
 *  get:
 *     tags:
 *     - Ping
 *     description: Returns API operational status
 *     responses:
 *       200:
 *         description: API is  running
 */
router.get('/ping', (req, res) => res.sendStatus(201))

router.use(userRouter)

export default router