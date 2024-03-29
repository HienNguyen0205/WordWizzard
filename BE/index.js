import express from 'express'
import router from './routes/index.js'
import swaggerDocs from './swagger.js'
import mongoose from "mongoose";
import cors from 'cors'
import dotenv from 'dotenv'
const app = express()
const port = 5001

dotenv.config();
const dataUrl = process.env.DB_URL

// Middleware
app.use(express.urlencoded({ extended: true }))
app.use(express.json())
app.use(express.static('./public'))
app.use(router)
app.use(cors())

mongoose.connect(dataUrl) // Convert dataUrl to a string
.then(() => console.log('MongoDB connected'))
.catch(err => console.error('Failed to connect to MongoDB', err));


app.listen(port, () => {
  console.log(`Example app listening at http://localhost:${port}`)
  swaggerDocs(app, port)
})