var express = require('express');
var router = express.Router();
const vision = require('@google-cloud/vision');
const client = new vision.ImageAnnotatorClient();

router.post('', async function (req, res, next) {
    // Performs label detection on the image file
    const [result] = await client.labelDetection(req.body.link);
    const labels = result.labelAnnotations;
    res.json(labels.map( a => ({
        description: a.description,
        score: a.score,
        confidence: a.confidence
    })))
})

module.exports = router;