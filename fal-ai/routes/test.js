var express = require('express');
var router = express.Router();
const {VertexAI} = require('@google-cloud/vertexai');

router.get('', async function (req, res, next) {
    analyze_video_with_audio()
})

async function analyze_video_with_audio(projectId = 'seismic-vista-436111-q7') {
    const vertexAI = new VertexAI({project: projectId, location: 'asia-east1-b'});
  
    const generativeModel = vertexAI.getGenerativeModel({
      model: 'gemini-1.5-flash',
    });
  
    const filePart = {
      file_data: {
        file_uri: 'https://aiapi.finanalyze.inspiral.site/test.mp4',
        mime_type: 'video/mp4',
      },
    };
    const textPart = {
      text: `
      Provide a description of the video.
      The description should also contain anything important which people say in the video.`,
    };
  
    const request = {
      contents: [{role: 'user', parts: [filePart, textPart]}],
    };
  
    const resp = await generativeModel.generateContent([{role: 'user', parts: ["Hello"]}]);
    const contentResponse = await resp.response;
    console.log(JSON.stringify(contentResponse));
  }
  // [END generativeaionvertexai_gemini_video_with_audio]
  
  analyze_video_with_audio(...process.argv.slice(2)).catch(err => {
    console.error(err.message);
    process.exitCode = 1;
  });
  

  module.exports = router;