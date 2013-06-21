#= require ../vendor/kinetic-v4.5.4

{ Stage, Layer, Animation, Polygon } = Kinetic

Math.HALF_PI = Math.PI / 2

ns App:Mouses: class

  worm_length: 20

  constructor: (@el, @movements) ->

    do @start_record unless Modernizr.touch

    if @movements?.length > 0
      do @setup_stage
      do @setup_worms
      @animation = new Animation @update_worms, @worms
      do @animation.start

  update_worms: =>
    for worm in @worms.children
      { path, index } = worm.attrs
      index += 1
      index = 1 - @worm_length if index >= path.length
      rindex = if index < 0 then 0 else index
      points = @get_shape path.slice(rindex, index + @worm_length)
      worm.setAttrs { index, points }

  setup_stage: =>
    @stage = new Stage
      container: @el[0]
      width: @el.width()
      height: @el.height()

  get_shape: (path) =>
    side1 = []
    side2 = []
    for point, i in path
      if i is 0 or i is path.length - 1
        side1.push point
      else
        prev_point = path[i - 1]
        delta =
          x: point.x - prev_point.x
          y: point.y - prev_point.y
        distance = Math.sqrt Math.pow(delta.x, 2) + Math.pow(delta.y, 2)
        distance *= 0.2
        angle1 = Math.atan2(delta.y, delta.x) - Math.HALF_PI
        angle2 = angle1 + Math.PI
        side1.push
          x: point.x + (distance * Math.cos(angle1))
          y: point.y + (distance * Math.sin(angle1))
        side2.unshift
          x: point.x + (distance * Math.cos(angle2))
          y: point.y + (distance * Math.sin(angle2))
    side1.concat side2

  setup_worms: =>
    @worms = new Layer
    @stage.add @worms
    for path, i in @movements
      @create_worm path

  create_worm: (path) =>
    @worms.add new Polygon
      x: 0
      y: 0
      fill: "#00e"
      opacity: Math.random() * 0.8 + 0.2
      path: path
      index: 0
      points: @get_shape path

  start_record: =>
    @recording = []
    $('.index').click @stop_record
    $(document).mousemove (e) => @recording.push x: e.pageX, y: e.pageY

  stop_record: =>
    $(document).off 'mousemove'
    $.ajax
      url: '/mouses'
      type: 'post'
      data: JSON.stringify { @recording }
      contentType: "application/json"
      success: (path) => @create_worm path