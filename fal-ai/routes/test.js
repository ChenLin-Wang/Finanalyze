var express = require('express');
var router = express.Router();


router.get('', async function (req, res, next) {
	// Imports the Google Cloud client library
	const vision = require('@google-cloud/vision');

	// Creates a client
	const client = new vision.ImageAnnotatorClient();

	// Performs label detection on the image file
	const [result] = await client.labelDetection('./resources/ChenLin Wang_fullBody.png');
	const labels = result.labelAnnotations;

	res.json(labels)
})

module.exports = router;