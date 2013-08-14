#= require ../vendor/page
#= require ../vendor/ns
#= require menu

#
# http://www.artzstudio.com/files/jquery-boston-2010/jquery.sonar/jquery.sonar.js
# http://luis-almeida.github.io/unveil/
# http://www.appelsiini.net/projects/lazyload

ns App:Main: class

  constructor: ->
    @menu = new App.Menu $ '#list'
    @body = $ 'body'
    @content = $ "#content"
    page '/:page', @load
    page '/', @root
    do page.start
    @script @body.attr('id')

  root: (ctx) => do @menu.open

  load: (ctx) =>
    id = ctx.path.substr 1
    return if id is @body.attr('id')
    $.get(id).done (data) =>
      html = $("<div>").append($.parseHTML(data))
      @content.html html.find("#content").html()
      document.title = html.find('title').text()
      @body.attr {id}
      @script id
      window.scrollTo 0,0

  script: (page) =>
    if App.Pages[page]
      @current = new App.Pages[page]

$(document).ready ->
  window.app = new App.Main