#= require vendor/kinetic-v4.5.4.min

{Stage, Layer, Rect, Animation, Spline} = Kinetic

ns App:Pages:About:

  init: ->

    @stage = new Stage
      container: 'about-background'
      width: 1200
      height: 800

    @rects = new Layer
    @lines = new Layer
    @stage.add @rects
    @stage.add @lines

    @animation = new Animation (=> do @draw), @rects
    do @animation.start

    do @draw_lines

  drop: ->
    @rects.add new Rect
      speed: x: 0, y: Math.random() * 2 + 1
      x: Math.round(Math.random() * 150) * 5
      y: -12
      width: 3
      height: 12
      fill: '#ccc'

  draw_lines: ->

    for n in [0..30]

      pos = Math.random() * 2 - 1
      width = Math.random()
      points = [x: 0, y: 0]
      for i in [0...800]
        pos += 0.02
        last_point = points[points.length - 1]
        x = last_point.x + Math.sin(pos) * width
        y = last_point.y + width
        width *= 0.998
        points.push {x, y}

      @lines.add new Spline
        points: points
        stroke: '#fff'
        fill: '#fff'
        tension: 1
        x: Math.random() * @stage.getWidth()
        y: 0

      @lines.draw()

  draw: (frame) ->

    do @drop

    @rects.getChildren().each (rect) =>
      {speed, x, y} = rect.getAttrs()
      pos =
        x: x + speed.x
        y: y + speed.y
      if pos.y > 800
        rect.destroy()
      rect.setAttrs pos


do App.Pages.About.init