#= require vendor/kinetic-v4.5.4.min

{ Stage, Layer, Line, Circle, Animation } = Kinetic

ns App:Mouses:

  record: []

  init: (@el, @movements) ->

    do @setup_stage
    do @setup_background
    do @setup_mouses

    @el.click => @stop_record()
    @start_record()

    @timer = setInterval (=> do @draw), 1000 / 24

  draw: ->
    do @draw_background
    do @draw_mouses

  draw_background: ->
    points = []
    @mouses.getChildren().each (mouse) ->
      {x, y} = mouse.getAttrs()
      points.push {x, y}
    @line.setAttrs {points}
    do @background.draw

  draw_mouses: (frame) ->
    @mouses.getChildren().each (mouse) ->
      path = mouse.getAttr('path')
      mouse.setAttrs path.shift()
      if path.length is 0
        mouse.setAttr 'path', mouse.getAttr('ogpath').reverse().slice()
    do @mouses.draw

  setup_stage: ->
    @stage = new Stage
      container: @el[0]
      width: @el.width()
      height: @el.height()

  setup_background: ->
    @background = new Layer
    @line = new Line(stroke: '#222', strokeWidth: 3, points: [x:0,y:0])
    @background.add @line
    @stage.add @background

  setup_mouses: ->
    @mouses = new Layer
    for path, i in @movements
      last_path = i is @movements.length - 1
      fill = if last_path then 'red' else '#222'
      @mouses.add new Circle
        fill: fill
        radius: 25
        path: path
        ogpath: path.slice()
        stroke: '#000'
        strokeWidth: 3
    @stage.add @mouses

  start_record: ->
    @el.on mousemove: (e) =>
      offset = @el.offset()
      @record.push
        x: e.pageX - offset.left
        y: e.pageY - offset.top

  stop_record: ->
    @el.off 'mousemove'
    $.post '/mouses', movements: @record

  destroy: ->
    clearInterval @timer
