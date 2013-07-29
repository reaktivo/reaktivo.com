ns App:Pages:lnh: class

  constructor: ->

    $('body').on 'click', '.mobile, .desktop', (e) =>
      method = $(e.currentTarget).attr 'class'
      do this[method]

  mobile: =>
    console.log 'mobile'
    $('.responsive-demo').animate(width: 320, height: 480)

  desktop: =>
    console.log 'desktop'
    $('.responsive-demo').animate(width: 800, height: 640)

  destroy: ->
