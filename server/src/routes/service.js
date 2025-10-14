const express = require('express')
const router = express.Router()
const serviceController = require('../app/controllers/ServiceController')

router.get('/get', serviceController.showall)

module.exports = router;