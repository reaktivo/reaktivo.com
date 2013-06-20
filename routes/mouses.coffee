mouses = do require('../lib/mouses')

module.exports = (app) ->

  app.get '/mouses', (req, res, next) ->
    mouses.get (err, data) ->
      res.send data

  app.post '/mouses', (req, res, next) ->
    mouses.add req.body.recording, (err) ->
      if err
        res.send 500
      else
        res.send 200, req.body.recording
