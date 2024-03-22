import express from 'express'
import router from './routes/index.js'
import swaggerDocs from './swagger.js'
import mongoose from "mongoose";
import cors from 'cors'
import dotenv from 'dotenv'
const app = express()

dotenv.config();
const port = process.env.PORT || 5001
const dbUrl = process.env.DB_URL;

// Middleware
app.use(express.urlencoded({ extended: true }))
app.use(express.json())
app.use(express.static('./public'))
app.use(router)
app.use(cors())

mongoose.connect(dbUrl)
.then(() => console.log('MongoDB connected'))
.catch(err => console.error('Failed to connect to MongoDB', err));


app.listen(port, () => {
  console.log(`Example app listening at http://localhost:${port}`)
  swaggerDocs(app, port)
})