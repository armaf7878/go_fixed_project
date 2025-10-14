const accountRouter = require('./account')
const homeRouter = require('./home')

function route(app){
    app.use('/account', accountRouter)
    app.use('/home', homeRouter)
}

module.exports = route