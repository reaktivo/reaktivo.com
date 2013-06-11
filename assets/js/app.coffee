#= require vendor/page
#= require vendor/ns

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
    page '/:page', $.proxy this, 'load'
    do @script

  load: (ctx) ->
    id = ctx.path.substr(1)
    @visible = yes
    $.get(id).success (data) =>
      html = $("<div>").append($.parseHTML(data)).find("#content").html()
      @content.html html
      @body.attr {id}
      do @script

  script: ->
    page = @body.attr 'id'
    if App.Pages[page]
      do App.Pages[page].init


  animate: ->
    @items.each (i) ->
      $(this).delay(80 * i).animate opacity: 1

  list_classes: ->
    (App.Item.page a for a in @items).join " "

  widest: ->
    val = Math.max.apply null, ($(a).outerWidth(yes) for a in @items)
    @_widest = val

  Item:

    click: (e) ->
      do e.preventDefault
      page "/#{App.Item.page this}"

    page: (a) -> $(a).attr('href').substr(1)

    mousemove: (e) ->
      el = $ e.currentTarget
      {left} = el.offset()
      porc = Math.floor((e.clientX - left) / el.outerWidth() * 100)

$(document).ready -> do App.init