const createError = require('http-errors');
const express = require('express');
const fs = require('fs');
const path = require('path');
const cookieParser = require('cookie-parser');
const logger = require('morgan');

var indexRouter = require('./routes/index');
var testRouter = require('./routes/test');

const geminiPromptPath = path.join(__dirname, 'gemini_prompts.txt');
const dbTableStructPath = path.join(__dirname, 'database_table_structs.txt');
const geminiQuesPromptPath = path.join(__dirname, 'gemini_ques_prompts.txt');
var geminiPrompt
var quesPrompt
try {
    geminiPrompt = fs.readFileSync(geminiPromptPath, 'utf8') + '\n' + fs.readFileSync(dbTableStructPath, 'utf-8');
    quesPrompt = fs.readFileSync(geminiQuesPromptPath, 'utf-8')
} catch (err) {
    throw err
}

var app = express();

// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'jade');

app.use(logger('dev'));
app.use(express.json({limit: '50mb'}));
app.use(express.urlencoded({limit: '50mb', extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

app.use('/chat', (req, res, next) => { req.geminiPrompt = geminiPrompt; req.quesPrompt = quesPrompt; indexRouter(req, res, next) });
app.use('/test', testRouter);
app.use(express.static('public'))
// app.use('/users', usersRouter);

// catch 404 and forward to error handler
app.use(function (req, res, next) {
    next(createError(404));
});

// error handler
app.use(function (err, req, res, next) {
    // set locals, only providing error in development
    res.locals.message = err.message;
    res.locals.error = req.app.get('env') === 'development' ? err : {};

    // render the error page
    res.status(err.status || 500);
    res.render('error');
});

module.exports = app;
