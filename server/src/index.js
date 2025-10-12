const express = require('express')
const app = express()
const port = 8000

//Parse Json
app.use(express.json()) 

//connect to db
const db = require('./config/db')
db.connect()

//Get Model
const User = require('./app/models/User')

//Route Init
const route = require('./routes')
route(app)


app.get('/', (req, res) => 
    User.find({})
    .then(users => res.json(users))
    .catch(err => res.status(500).json({ error: err.message })))



app.listen(port, () => console.log(`App Listening At http://localhost:${port}`))