process.chdir __dirname
express = require 'express'
favicon = require 'serve-favicon'
morgan = require 'morgan'
bodyParser = require 'body-parser'
methodOverride = require 'method-override'
serveStatic = require 'serve-static'
errorHandler = require 'errorhandler'
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
app.use favicon join(__dirname, "assets", "favicon.ico")
app.use morgan('dev')
app.use bodyParser()
app.use methodOverride()
app.use assets(helperContext: app.locals)
app.use serveStatic join __dirname, "views/pages"
app.use serveStatic join __dirname, "assets"

# load locals and routes into app
load('locals', cwd: __dirname).into(app)
load('routes', cwd: __dirname).into(app)

# configure for development
if process.env.NODE_ENV is not 'production'
  app.use errorHandler()

# start application
app.listen app.get 'port'
console.log "Express server listening on port #{app.get('port')}"
