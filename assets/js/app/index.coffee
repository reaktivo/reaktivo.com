#= require vendor/page
#= require vendor/ns
#= require app/menu

ns App:

  init: ->
    do App.Menu.init
    @body = $ 'body'
    @content = $ "#content"
    page '/:page', $.proxy this, 'load'
    @script @body.attr('id')

  load: (ctx) ->
    id = ctx.path.substr(1)
    $.get(id).done (data) =>
      @content.html $("<div>").append($.parseHTML(data)).find("#content").html()
      @body.attr {id}
      @script id

  script: (page) ->
    do App.Pages[page].init if App.Pages[page]

$(document).ready -> do App.init