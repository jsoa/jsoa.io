

# Module dependencies.

express = require 'express'
mongoose = require 'mongoose'

routes = require './routes'
models = require './models'
user = require './routes/user'
http = require 'http'
path = require 'path'

# DB
mongoose.connect 'mongodb://nodejitsu:a9660d9df199b6d9b2b663c8f024611f@linus.mongohq.com:10054/nodejitsudb1188126835'
db = mongoose.connection

db.on 'error', console.error.bind(console, 'connection error')
db.once 'open', ->
  console.log 'db connection OK'

# App
app = express()

app.configure ->
  app.set 'port', process.env.PORT || 3000
  app.set 'views', __dirname + '/views'
  app.set 'view engine', 'jade'

  app.use express.favicon()
  app.use express.logger('dev')
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use express.cookieParser('your secret here')
  app.use express.session()
  app.use app.router
  app.use require('stylus').middleware(__dirname + '/public')
  app.use express.static(path.join(__dirname, 'public'))


app.configure 'development', ->
  app.use express.errorHandler()


# Routes
app.get '/', routes.index

# RPCS
app.get '/rpc/activity', routes.rpcs.activity
app.get '/rpc/gists', routes.rpcs.gists
app.get '/rpc/repos', routes.rpcs.repos
app.get '/rpc/orgs', routes.rpcs.orgs

http.createServer(app).listen app.get('port'), ->
  console.log "Express server listening on port #{app.get('port')}"
