const express = require('express')
const app = express()
const port = 8000
const cors = require('cors');
const morgan = require('morgan');

//Parse Json
app.use(express.json()) 

// 🔴 BẬT CORS + PRELIGHT Ở ĐÂY (trước routes)
const corsOptions = {
  origin: true, // dev cho phép mọi origin; prod nên truyền mảng domain được phép
  credentials: true,
  methods: ['GET','POST','PUT','PATCH','DELETE','OPTIONS'],
  allowedHeaders: ['Content-Type','Authorization'],
};
app.use(cors(corsOptions));
app.options(/.*/, cors(corsOptions));    // 👈 xử lý preflight OPTIONS

app.use(morgan('dev'));

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