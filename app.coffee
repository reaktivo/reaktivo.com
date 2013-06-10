require 'js-yaml'
express = require 'express'
stylus = require 'stylus'
assets = require 'connect-assets'
load = require 'express-load'
{join} = require 'path'
{extend} = require 'underscore'

# create app
module.exports = app = express()

# settings
app.set 'root', __dirname
app.set 'port', process.env.PORT or 3000
app.set 'views', join __dirname, "views"
app.set 'view engine', 'jade'
app.set 'title', ""

# middleware
app.use express.favicon join(__dirname, "assets", "favicon.ico")
app.use express.logger('dev')
app.use express.bodyParser()
app.use express.methodOverride()
app.use app.router
app.use assets()
app.use express.static join __dirname, "assets"

# load locals and routes into app
load('locals', extlist: ['.yml']).into(app)
load('routes').into(app)

# configure for development
app.configure 'development', ->
  app.use express.errorHandler()

# start application
app.listen app.get 'port'
console.log "Express server listening on port #{app.get('port')}"