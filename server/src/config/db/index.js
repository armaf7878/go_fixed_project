const mongoose = require('mongoose')

async function connect() {
    try {
        await mongoose.connect('mongodb://localhost:27017/go_fix_db', { serverSelectionTimeoutMS: 2000 })
        console.log('Connected Successfully', mongoose.connection.readyState)
    } catch (error) {
        console.log('Connection Failed:', error.message)
    }
}
module.exports = {connect}