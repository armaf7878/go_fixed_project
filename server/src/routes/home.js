const express = require('express')
const router = express.Router()
const homeController = require('../app/controllers/HomeController')

router.get('/service', homeController.showall)

module.exports = router;