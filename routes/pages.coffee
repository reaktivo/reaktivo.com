module.exports = (app) ->

  default_page = 'about'

  app.get '/:page?', (req, res, next) ->
    page = req.params.page or default_page
    title = app.locals.pages[page]
    if title
      title = title + " — Reaktivo.com"
      res.render "pages/#{page}/#{page}", {page, title}
    else do next