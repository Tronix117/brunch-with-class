module.exports = class DefaultController extends Controller

  index: (params, route)->
    @redirectTo 'category#index'

  error: (params, route)->
    console.error 'There is error: ', arguments