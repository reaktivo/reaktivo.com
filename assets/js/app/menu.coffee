#= require ../vendor/ns
#= require ../vendor/jquery.swipe

ns App:Menu: class

  constructor: ->

    @touch = {}

    # setup selectors
    @list = $ 'body > nav ul'
    @items = $ 'a', @list
    @document = $ document
    @body = $ '#body'
    @content = $ '#content'

    # setup events

    # WebFontConfig.ready @animate
    do @animate
    @items.click @navigate
    @list.on
      mouseenter: @open
      mouseleave: @close
    @document.on
      touchstart: @touchstart
      touchmove:  @touchmove
      touchend:   @touchend
    @document.on { click: @index }, '.index'

    # open menu if device is touch capable
    if Modernizr.touch or document.location.pathname is "/"
      do @open
    else
      do @close

  index: (e) =>
    do e?.preventDefault
    page '/'

  open: (e) =>
    do e?.preventDefault
    width = if Modernizr.mq 'screen and (max-width:320px)'
      320
    else
      Math.max.apply null, ($(a).outerWidth(yes) for a in @items)
    @move 0, width

  close: (e) =>
    do e.preventDefault if e
    @move -40, 0

  move: (list, content) =>
    @list.stop().animate left: list
    @content.stop().animate left: content

  animate: =>
    @items.each (i) ->
      $(this).delay(80 * i).transition opacity: 1

  navigate: (e) =>
    do e.preventDefault
    do @close if Modernizr.touch
    page $(e.currentTarget).attr('href')

  ### Touch Handlers ###

  touchstart: (e) =>
    @touch.start =
      x: e.originalEvent.pageX
      y: e.originalEvent.pageY

  touchmove: (e) =>
    @touch.end =
      x: e.originalEvent.pageX
      y: e.originalEvent.pageY
    @touch.delta =
      x: @touch.end.x - @touch.start.x
      y: @touch.end.y - @touch.start.y
    if Math.abs(@touch.delta.x) > Math.abs(@touch.delta.y) and @touch.delta.x > 0
      do e.preventDefault
      @content.css left: @touch.delta.x

  touchend: (e) =>
    if @touch.delta
      do if @touch.delta.x > 60 then @open else @close
