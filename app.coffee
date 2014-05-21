process.chdir __dirname
require 'js-yaml'
express = require 'express'
stylus = require 'stylus'
assets = require 'connect-assets'
load = require 'express-load'
nconf = require 'nconf'
{join} = require 'path'
{extend} = require 'underscore'

nconf.env().file(file: join(__dirname, 'config.json'))

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
app.use assets()
app.use express.static join __dirname, "views/pages"
app.use express.static join __dirname, "assets"
app.use app.router

# load locals and routes into app
load('locals', extlist: ['.yml'], cwd: __dirname).into(app)
load('routes', cwd: __dirname).into(app)

# configure for development
app.configure 'development', ->
  app.use express.errorHandler()

# start application
app.listen app.get 'port'
console.log "Express server listening on port #{app.get('port')} on #{process.env.NODE_ENV} mode"
