// server.js
const express = require('express')
require("dotenv").config();

const app = express()
app.get('/', (req, res) => {
	res.send(process.env.TEST_ENV)
})
app.listen(3000, () => {
	console.log('Server is up on 3000')
})
