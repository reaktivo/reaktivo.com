nconf = require 'nconf'
REDIS_HOST = nconf.get 'REDIS_HOST'
REDIS_PORT = nconf.get 'REDIS_CONF'
REDIS_AUTH = nconf.get 'REDIS_AUTH'
redis = require('redis').createClient REDIS_PORT, REDIS_HOST
redis.auth REDIS_AUTH


valid = (recording) ->
  return false if not Array.isArray(recording) or recording.length is 0
  for point in recording
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

  add = (recording, callback) ->
    if valid recording
      redis.multi()
        .lpush(options.key, JSON.stringify(recording))
        .ltrim(options.key, 0, options.len - 1)
        .exec(callback)
    else
      callback new Error 'Invalid data'

  middleware = (req, res, next) ->
    get (err, data) ->
      res.locals.mouses = data
      do next

  { get, add, middleware }