{ REDIS_HOST, REDIS_PORT, REDIS_AUTH } = process.env
redis = require('redis').createClient REDIS_PORT, REDIS_HOST
redis.auth REDIS_AUTH


valid = (data) ->
  return false unless Array.isArray data
  for point in data
    keys = Object.keys point
    return false if keys.length isnt 2
    for d in ['x', 'y']
      return false if point[d] is undefined
  true

module.exports = (options = {}) ->
  options.len or= 10
  options.key or= "reaktivo:mouses"

  get = (callback) ->
    redis.lrange options.key, 0, -1, (err, mouses) ->
      return callback err if err
      callback err, mouses.map (m) -> JSON.parse m

  add = (data, callback) ->
    if valid data
      redis.multi()
        .lpush(options.key, JSON.stringify(data))
        .ltrim(options.key, 0, options.len - 1)
        .exec(callback)
    else
      callback new Error 'Invalid data'

  middleware = (req, res, next) ->
    get (err, data) ->
      res.locals.mouses = data
      do next

  { get, add, middleware }