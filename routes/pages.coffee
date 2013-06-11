mouses = do require('../lib/mouses')

module.exports = (app) ->

  default_page = 'about'

  app.get '/:page?', mouses.middleware, (req, res, next) ->
    page = req.params.page or default_page
    title = app.locals.pages[page]
    if title
      res.render "pages/#{page}", {page, title}
    else do next

  app.post '/mouses', (req, res, next) ->
    mouses.add req.body.movements, (err) ->
      res.send if err then 500 else 200