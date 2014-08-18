module.exports = class CategoryController extends Controller

  beforeAction: (params, route)->
    super

    @reuse 'layout', LayoutView

    global._dummyCollection = new Collection unless global._dummyCollection
    @reuse 'pager', NavPagerView,
      region: 'tab-pager'
      collection: global._dummyCollection # just passing fake collection

  index: (params, route)->
    @view = new CategoryView
      region: 'content'
      collection: mediator.categories