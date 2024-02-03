const express = require('express');

const authenticationController = require('../controllers/authenticationController');

const router = express.Router();

router.get('/', authenticationController.auth);

module.exports = router;
