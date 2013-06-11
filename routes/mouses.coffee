mouses = do require('../lib/mouses')

module.exports = (app) ->

  app.get '/mouses', (req, res, next) ->
    mouses.get (err, data) ->
      res.send data

  app.post '/mouses', (req, res, next) ->
    mouses.add req.body.movements, (err) ->
      res.send if err then 500 else 200