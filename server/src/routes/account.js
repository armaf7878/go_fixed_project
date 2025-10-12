const express = require('express')
const router = express.Router();
const accountController = require('../app/controllers/AccountController')

router.get('/showall', accountController.showall)
router.post('/login', accountController.login)
router.post('/create', accountController.create)

module.exports = router;        