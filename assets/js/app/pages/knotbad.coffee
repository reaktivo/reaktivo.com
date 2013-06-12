#= require ../../jquery.iphone

ns App:Pages:knotbad:

  init: ->
    @iphone = $('.iphone').iphone()
    @iphone.css left: -400, opacity: 0, rotate: -20
    @iphone.transition left: 0, opacity: 1, rotate: 0, 3000, =>
      @description.transition left: 0, opacity: 1

    @description = $('.description')
    @description.css left: -300, opacity: 0


  destroy:
    App.Mouses.destroy()
