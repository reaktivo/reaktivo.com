plan = new (require 'flightplan')
module.exports = plan

  .briefing
    debug: no
    destinations:
      production:
        host: 'drop.reaktivo.com'
        username: 'root'
        privateKey: '~/.ssh/id_rsa'

  .local (local) ->
    local.git 'push'

  .remote (remote) ->
    remote.with "cd reaktivo.com", ->
      remote.git 'pull'
      remote.npm 'install --production'
      remote.exec "pm2 reload reaktivo.com"
