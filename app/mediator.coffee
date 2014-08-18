mediator = module.exports = Chaplin.mediator

# mediator.login = (accessToken) ->
#   return if mediator.user
#   localStorage.setItem 'accessToken', accessToken
#   mediator.createUser()
#   mediator.user.set {accessToken}
#   mediator.user.fetch().then ->
#     mediator.publish 'loginStatus', true

# mediator.logout = (accessToken) ->
#   return unless mediator.user
#   localStorage.removeItem 'accessToken'
#   mediator.removeUser()
#   mediator.publish 'loginStatus', false