mediator = module.exports = Chapeau.mediator

# mediator.checkOnlineStatus = (cb)->
#   Backbone.ajax(config.api.endpoint,
#     type: 'HEAD'
#   ).success((data, state, xhr)->
#     mediator.checkOnlineStatusCallback(true)
#   ).error((xhr, state)->
#     mediator.checkOnlineStatusCallback(false)
#   ).always ->
#     cb?()

# mediator.checkOnlineStatusCallback = (isOnline)->
#   prevOnline = mediator.isOnline
#   mediator.isOnline = isOnline

#   if prevOnline isnt null and prevOnline isnt isOnline
#     log if mediator.isOnline then 'Online!' else 'Offline!'
#     mediator.publish 'app:onlineChanged'

#   setTimeout (-> mediator.checkOnlineStatus()), 10000