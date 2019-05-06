

# Module dependencies.

express = require 'express'
mongoose = require 'mongoose'
http = require 'http'
path = require 'path'

routes = require './routes'
models = require './models'
user = require './routes/user'
config = require './config'
db = require './db'


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


redirectToSecure = (req, res, next) ->
  if req.headers['x-forwarded-proto'] == 'https' or req.host == 'localhost'
    return next()
  res.redirect 'https://' + req.host + req.path


app.all '*', redirectToSecure

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

if not config.cron.standalone
  jobs = require './jobs'
