#= require ../vendor/ns
#= require ../vendor/jquery.swipe

ns App:Menu:

  init: ->
    @list = $ '#list'
    @items = $ 'a', @list
    @body = $ '#body'
    @content = $ '#content'
    WebFontConfig.ready => do @animate
    @items.on 'click mouseup': => do @navigate
    @list.on
      'mouseover touchstart' : => do @open
      'mouseout touchend'  : => do @close
    do @close

  open: ->
    @list.css left: 0
    @content.css left: @widest()

  close: ->
    @list.css left: -40
    @content.css left: ""

  animate: ->
    @items.each (i) ->
      $(this).delay(80 * i).animate opacity: 1

  widest: ->
    Math.max.apply null, ($(a).outerWidth(yes) for a in @items)

  navigate: (e) ->
    do e.preventDefault
    page $(this).attr('href')
