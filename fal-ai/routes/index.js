const { GoogleGenerativeAI } = require("@google/generative-ai")
const genAI = new GoogleGenerativeAI("AIzaSyB7j2gX8SNy5AxNHdiXp9x9gS5mNj3Fcqk")
const model = genAI.getGenerativeModel({ model: "gemini-1.5-pro" })

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
        chunkText = removeJsonMarkdown(chunkText)
        console.log(chunkText)
        res.json(JSON.parse(chunkText))
    } catch (err) {
        console.log(err)
        res.status(500).json({ error: err.toString() })
    }
});

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
        chunkText = removeJsonMarkdown(chunkText)
        console.log(`sql: ${chunkText}`)
        res.json(JSON.parse(chunkText))
    } catch (err) {
        console.log(err)
        res.status(500).json({ error: err.toString() })
    }
});

/*
req.ques: String
*/

router.post('/title', async function (req, res, next) {
    try {
        const chat = model.startChat({})
        const reply = await chat.sendMessage(`make a short title for this question: "${req.body.ques}", return only the one line title as pure text`)
        res.json({title: reply.response.text().split('\n')[0]})
    } catch (err) {
        console.log(err)
        res.status(500).json({ error: err.toString() })
    }
});

function removeJsonMarkdown(input) {
    // 使用正则表达式匹配和去除 ```json 和 ```
    return input.replace(/```json\s*([\s\S]*?)```/g, '$1').trim();
}

module.exports = router;