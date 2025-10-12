const {default: mongoose} = require('mongoose')
const Schema = mongoose.Schema
const ObjectID = Schema.ObjectId

const Course = new Schema({
    fullname: {
        type: String,
        required: true
    }
})

module.exports = mongoose.model('Course', Course)
