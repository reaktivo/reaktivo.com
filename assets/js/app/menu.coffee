#= require ../vendor/ns
#= require ../vendor/jquery.swipe

ns App:Menu:

  init: ->
    @list = $ '#list'
    @items = $ 'a', @list
    @body = $ '#body'
    @content = $ '#content'
    @classes = @list_classes()
    WebFontConfig.ready => do @animate
    @items.on 'click mouseup', App.Menu.Item.click
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

  list_classes: ->
    ($(a).attr('href').substr(1) for a in @items).join " "

  widest: ->
    val = Math.max.apply null, ($(a).outerWidth(yes) for a in @items)
    @_widest = val

  Item:

    click: (e) ->
      do e.preventDefault
      page $(this).attr('href')

    # mousemove: (e) ->
    #   el = $ e.currentTarget
    #   {left} = el.offset()
    #   porc = Math.floor((e.clientX - left) / el.outerWidth() * 100)
