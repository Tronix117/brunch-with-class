# Chaplin Smart Navigation
#
# Chaplin.mediator.smartNavigate params, options
#
# Add a smartNavigate method to Chaplin.mediator, it will automaticaly select
# the best route using only route params in first argument.
#
# Keep automaticaly current route params, except if they are explicitely set to
# null or if `reset: true` is passed as second argument.
#
# Exemple:
#
#   First, don't forget to require this file before Application is initialized.
#
#   Then, simply add an option `smart: true` on each route that should benefit
#   from smart navigation.
#
#   `routes.coffee` exemple:
#     ...
#     match '/posts'                      , 'posts#show', smart: true
#     match '/posts/:postId'              , 'posts#show', smart: true
#     match '/users/:userId/posts'        , 'user#show' , smart: true
#     match '/users/:userId/posts/:postId', 'posts#show', smart: true
#     ...
#
#   Now you can call Chaplin.mediator.smartNavigate wherever you want:
#     # Following methods are called in this specific order
#
#     Chaplin.mediator.smartNavigate userId: 12
#     # -> will trigger '/users/12/posts'
#
#     Chaplin.mediator.smartNavigate postId: 23
#     # -> will trigger '/users/12/posts/23'
#
#     Chaplin.mediator.smartNavigate userId: null
#     # -> will trigger '/posts/23'
#
#     Chaplin.mediator.smartNavigate()
#     # -> will trigger '/posts/23' again
#
#     Chaplin.mediator.smartNavigate null, reset: true
#     # -> will trigger '/posts'
#
#   Magic! Just make sure two routes doesn't have the same set of params.
#
# @author Jeremy Trufier <jeremy@trufier.com> (https://github.com/Tronix117)
# @gist https://gist.github.com/Tronix117/7917925
# @license MIT
# -------------------------------------

mediator = module.exports = Chaplin.mediator

# Will keep an history of last know route parameters
mediator.lastRouteParams = {}

# Register smart route using sorted paramNames as key, format of key is:
#   `paramsName0|paramsNameA|paramsNameB|paramsNameC`
mediator._smartRoutes = {}

# Subscribe to the global event that match routes, before controller get called
mediator.subscribe 'router:match', (route, actionParams, options)->
  mediator.lastRouteParams = actionParams

# Override match method of the Router to get routes as they are created
Chaplin.Router.prototype._match = Chaplin.Router.prototype.match
Chaplin.Router.prototype.match = ->
  # Call the former method, which will create the route
  route = Chaplin.Router.prototype._match.apply @, arguments

  # if the route as the `smart` option, then we can use it
  if route.options.smart
    # Format the route as _smartRoutes expects
    sortedParams = route.allParams.slice().sort().join('|')

    # Make sure no two routes use same params to avoid development mistakes
    if mediator._smartRoutes[sortedParams]
      throw new Error "router#match: smart routes must have unique params set. \
Route <#{route.name}> and <#{mediator._smartRoutes[sortedParams].name}> have \
the same params set"
    
    # Finaly save this route for smart use
    mediator._smartRoutes[sortedParams] = route

  # Finaly return the route like former method does
  route

# Keep last known parameters when navigate, eventually add new ones, remove
#  `null` ones and select the best route for those parameters.
#
# `options` may contain following:
#   reset: if true only new parameters will be kept, old ones will be removed
mediator.smartNavigate = (params = {}, options = {})->
  # Add lastRouteParams to params unless reset option is true
  params = _.extend {}, mediator.lastRouteParams, params unless options.reset

  # Get list of params key for params that contain a value and format it as
  # _smartRoutes expects
  keys = _.compact((key if val) for key, val of params).sort().join('|')

  # Retrieve the best route using params
  console.log keys, mediator._smartRoutes
  unless route = mediator._smartRoutes[keys]
    throw new Error 'mediator#smartNavigate: request was not smart routed'

  # Finaly trigger the route
  mediator.execute 'router:route', route.name, params