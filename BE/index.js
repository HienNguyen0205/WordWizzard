import express from 'express'
import router from './routes/index.js'
import swaggerDocs from './swagger.js'
import mongoose from "mongoose";
import cors from 'cors'
const app = express()
const port = 5001

// Middleware
app.use(express.urlencoded({ extended: true }))
app.use(express.json())
app.use(express.static('./public'))
app.use(router)
app.use(cors())

mongoose.connect('mongodb+srv://maiduy190802:1Gwal0o5GFaPBrSH@wordwizard.cz0yj5d.mongodb.net/word_wizard?retryWrites=true&w=majority&appName=WordWizard')
.then(() => console.log('MongoDB connected'))
.catch(err => console.error('Failed to connect to MongoDB', err));


app.listen(port, () => {
  console.log(`Example app listening at http://localhost:${port}`)
  swaggerDocs(app, port)
})