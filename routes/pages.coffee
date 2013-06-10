module.exports = (app) ->
  app.get '/', (req, res) ->
    res.render 'pages/home', title: 'My Page'
