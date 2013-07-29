#= require ../vendor/two



ns App:Bubbles: class

  circles: []
  max_size: 45
  force_multiplier: 0.9

  constructor: (@el, @movements) ->
    if @movements?.length > 0
      @movements = @attributize @movements
      params = { width: @el.width(), height: @el.height() }
      @scene = new Two(params).appendTo(@el[0])
      @scene.bind 'update', @update
      @scene.play()

  update: =>
    # for path in @movements
    path = @movements[2]
    do =>
      point = path[path.pos]
      if point.radius > 0
        circle = @scene.makeCircle(point.x, point.y, point.radius)
        circle.fill = '#00e'
        circle.noStroke()
        circle.force = x: @rand(50), y: @rand(50)
        @circles.push circle
      path.pos += 1
      if path.pos >= path.length then path.pos = 0
    removes = []
    for circle in @circles
      circle.translation.x += circle.force.x
      circle.translation.y += circle.force.y + 10
      if circle.translation.y > @scene.height
        removes.push circle
      circle.force.x *= 0.86
      circle.force.y *= 0.04
    for circle in removes
      circle.parent.remove(circle)
      @circles.splice(@circles.indexOf(circle), 1)

    this

  attributize: (movements) =>
    for path in movements
      path.pos = 0
      for point, i in path
        if i is 0
          point.radius = 0
        else
          prev_point = path[i - 1]
          delta =
            x: point.x - prev_point.x
            y: point.y - prev_point.y
          force = Math.sqrt Math.pow(delta.x, 2) + Math.pow(delta.y, 2)
          point.radius = Math.max 0, @max_size - force * @force_multiplier
    movements

  rand: (a) -> Math.random() * a * 2 - a