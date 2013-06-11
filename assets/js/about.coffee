
#= require mouses

ns App:Pages:About:

  init: ->
    App.Mouses.init $ '#mouses'

do App.Pages.About.init