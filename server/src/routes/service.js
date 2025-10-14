const express = require('express')
const router = express.Router()
const serviceController = require('../app/controllers/ServiceController')

router.get('/get', serviceController.showall)
router.post('/add', serviceController.add)
router.post('/delete/:id', serviceController.delete)

module.exports = router;