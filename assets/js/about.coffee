#= require vendor/kinetic-v4.5.4.min

{Stage, Layer, Rect, Animation} = Kinetic

ns App:Pages:About:

  init: ->

    @stage = new Stage
      container: 'about-background'
      width: 1200
      height: 800

    @rects = new Layer
    @stage.add @rects

    @animation = new Animation (=> do @draw), @rects
    do @animation.start

  drop: ->
    @rects.add new Rect
      speed: x: 0, y: Math.random() * 2 + 1
      x: Math.round(Math.random() * 150) * 5
      y: -12
      width: 3
      height: 12
      fill: '#ccc'

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