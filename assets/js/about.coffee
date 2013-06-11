#= require vendor/kinetic-v4.5.4.min

{Stage, Layer, Rect, Animation, Spline} = Kinetic

ns App:Pages:About:

  force: 80

  init: ->
    @container = $('#about-background')
    @mouse = x: 0, y: 0, px: 0, py: 0
    @stage = new Stage
      container: @container[0]
      width: 1200
      height: 800

    @rects = new Layer
    @stage.add @rects

    @animation = new Animation (=> do @draw), @rects
    do @animation.start

    @container.mousemove (e) =>
      offset = @container.offset()
      @mouse =
        px: @mouse.x
        py: @mouse.y
        x: e.pageX - offset.left
        y: e.pageY - offset.top

  drop: ->
    @rects.add new Rect
      speed: x: 0, y: Math.random() * 4 + 1
      x: Math.round(Math.random() * 150) * 5
      y: -12
      width: 3
      height: 12
      fill: "#ccc"

  draw: (frame) ->

    do @drop

    @rects.getChildren().each (rect) =>
      {speed, x, y} = rect.getAttrs()
      attrs =
        x: x + speed.x
        y: y + speed.y
      distance =
        x: attrs.x - @mouse.x
        y: attrs.y - @mouse.y
      distance.abs = Math.sqrt(Math.pow(distance.x, 2) + Math.pow(distance.y, 2))
      if distance.abs < @force
        attrs.x += distance.x * 0.1
        attrs.y += distance.y * 0.1
      if attrs.y > 800
        rect.destroy()

      rect.setAttrs attrs


do App.Pages.About.init