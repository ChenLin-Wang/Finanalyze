const { GoogleGenerativeAI } = require("@google/generative-ai")
const genAI = new GoogleGenerativeAI("AIzaSyByNdiC3Szp9c_wFL1w_PkpIsOJkOF0FvE")
const model = genAI.getGenerativeModel({
    model: "gemini-1.5-pro",
})

var express = require('express');
var router = express.Router();

/*
req.prompts = {
    content: string,
}
req.body.histories = [
    [
        role: string,
        content: string,
    ],
]
*/

router.post('', async function (req, res, next) {
    try {
        const prompts = [`{text: "${req.body.prompts.content}", prompt: "${req.quesPrompt}"}`]
        const histories = [
            {
                role: "user",
                parts: [{ text: `{text: "${req.geminiPrompt}"}` }]
            }
        ].concat(req.body.histories.map(h => {
            return {
                role: h.role,
                parts: [{ text: h.role === 'user' ? `{text: "${h.content}"}` : `{raw_sql_result: "${h.content}"}` }]
            }
        }))
        const chat = model.startChat({ history: histories })
        const reply = await chat.sendMessageStream(prompts)
        var chunkText = ""
        for await (const chunk of reply.stream) chunkText += chunk.text()
        console.log(`origin: ${chunkText}`)
        if (chunkText.startsWith("```")) chunkText = removeJsonMarkdown(chunkText)
        let json = JSON.parse(chunkText)
        console.log(json)
        res.json(json)
    } catch (err) {
        errHandle(err, req, res)
    }
});
"[GoogleGenerativeAI Error]: Error fetching from https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-pro:streamGenerateContent?alt=sse: [400 Bad Request] * GenerateContentRequest.safety_settings[0]: element predicate failed: $.category in (HarmCategory.HARM_CATEGORY_HATE_SPEECH, HarmCategory.HARM_CATEGORY_SEXUALLY_EXPLICIT, HarmCategory.HARM_CATEGORY_DANGEROUS_CONTENT, HarmCategory.HARM_CATEGORY_HARASSMENT, HarmCategory.HARM_CATEGORY_CIVIC_INTEGRITY)\n"
/*
req.prompts = {
    content: string,
}
req.body.histories = [
    [
        role: string,
        content: string,
    ],
]
*/

router.post('/sql', async function (req, res, next) {
    try {
        const prompts = [`{raw_sql_result: "${req.body.prompts.content}", prompt: "${req.quesPrompt}"}`]
        const histories = [
            {
                role: "user",
                parts: [{ text: `{text: "${req.geminiPrompt}"}` }]
            }
        ].concat(req.body.histories.map(h => {
            return {
                role: h.role,
                parts: [{ text: h.role === 'user' ? `{text: "${h.content}"}` : `{raw_sql_result: "${h.content}"}` }]
            }
        }))
        const chat = model.startChat({ history: histories })
        const reply = await chat.sendMessageStream(prompts)
        var chunkText = ""
        for await (const chunk of reply.stream) chunkText += chunk.text()
        if (chunkText.startsWith("```")) chunkText = removeJsonMarkdown(chunkText)
        console.log(`sql: ${chunkText}`)
        res.json(JSON.parse(chunkText))
    } catch (err) {
        errHandle(err, req, res)
    }
});

/*
req.ques: String
*/

router.post('/title', async function (req, res, next) {
    try {
        const chat = model.startChat({})
        const reply = await chat.sendMessage(`make a short title for this question: "${req.body.ques}", return only the one line title as pure text`)
        res.json({ title: reply.response.text().split('\n')[0] })
    } catch (err) {
        if (err.status === 400) {
            console.log("Blocked")
            res.json({ title: "Untitled", blocked: true })
        } else {
            console.log(err)
            res.status(500).json({ error: err.toString() })
        }
    }
});

function errHandle(err, req, res) {
    if (err.status === 400) {
        console.log(err)
        res.json({ type: "text", text: err.toString(), blocked: true })
    }
}

function removeJsonMarkdown(input) {
    // 使用正则表达式匹配和去除 ```json 和 ```
    return input.replace(/```json\s*([\s\S]*?)```/g, '$1').trim();
}

module.exports = router;