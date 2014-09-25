module.exports = class ArticleController extends Controller

  beforeAction: (params, route)->
    super

    @reuse 'layout', LayoutView

    @reuse 'pager', NavPagerView,
      region: 'tab-pager'
      collection: dummyCollection # just passing fake collection