{map, each, extend, proxy} = $

ns App:

  init: ->
    @list = $ '#list'
    @items = $ 'a', @list
    @body = $ 'body'
    @content = $ '#content'
    @classes = @list_classes()
    WebFontConfig.ready => do @animate
    @items.click App.Item.click
    @list.on
      mouseover : =>
        @list.css left: 0
        @content.css left: @widest()
      mouseout  : =>
        @list.css left: -40
        @content.css left: ""
    @list.mouseout()

  load: (page) ->
    @visible = yes
    @content.load page, => @body.attr 'id', page

  animate: ->
    @items.each (i) ->
      $(this).delay(80 * i).animate opacity: 1

  list_classes: ->
    classes = for a in @items
      App.Item.page a
    classes.join " "

  widest: ->
    val = Math.max.apply null, ($(a).outerWidth(yes) for a in @items)
    @_widest = val

  Item:

    click: (e) ->
      do e.preventDefault
      App.load App.Item.page this

    page: (a) -> $(a).attr('href').substr(1)

    mousemove: (e) ->
      el = $ e.currentTarget
      {left} = el.offset()
      porc = Math.floor((e.clientX - left) / el.outerWidth() * 100)

$(document).ready -> do App.init