#= require ../mouses

ns App:Pages:about:

  init: ->
    $.get '/mouses', (movements) ->
      App.Mouses.init $('#mouses'), movements
  destroy:
    App.Mouses.destroy()