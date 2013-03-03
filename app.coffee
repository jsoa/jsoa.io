

# Module dependencies.

express = require 'express'
mongoose = require 'mongoose'

routes = require './routes'
models = require './models'
user = require './routes/user'
http = require 'http'
path = require 'path'
cron = require 'cron'

imports = require './imports'
config = require './config'

# DB
mongoose.connect config.mongo_connection
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
app.get '/about', routes.about

# RPCS
app.get '/rpc/activity', routes.rpcs.activity
app.get '/rpc/gists', routes.rpcs.gists
app.get '/rpc/repos/owned', routes.rpcs.repos(true)
app.get '/rpc/repos/watched', routes.rpcs.repos(false)
app.get '/rpc/orgs', routes.rpcs.orgs

http.createServer(app).listen app.get('port'), ->
  console.log "Express server listening on port #{app.get('port')}"


job1 = new cron.CronJob(
  '*/5 * * * *',
  ->
    imports.activity()
  , null, true)


job2 = new cron.CronJob(
  '55 * * * *',
  ->
    imports.repos()
    imports.orgs()
    imports.gists()
  , null, true)