module.exports = class DefaultController extends Controller

  beforeAction: (params, route)->
    super

    @reuse 'layout', LayoutView

  index: (params, route)->
    @redirectTo 'category#index'

  error: (params, route)->
    console.error 'There is error: ', arguments