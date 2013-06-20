#= require ../mouses

ns App:Pages:about: class

  constructor: ->
    $.get '/mouses', (movements) =>
      @mouses = new App.Mouses $('#mouses'), movements