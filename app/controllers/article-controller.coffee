AbstractAppController = require './abstract/app-controller'

module.exports = class ArticleController extends AbstractAppController

  index: (params, route)->
    # Do we want to filter by categoryId or to index all articles ?
    articles = if params.categoryId?
      mediator.articles.where {category_id: ~~params.categoryId}
    else mediator.articles

    @view = new ArticleIndexView
      region: 'content'
      model: mediator.categories.get ~~params.categoryId # contextuals infos
      collection: articles

  show: (params, route)->
    model = mediator.articles.get ~~params.articleId
    categoryId = model.get 'category_id'

    articles = mediator.articles.where {category_id: categoryId}
    
    # We need an extra layer between global Layout and article to handle
    # some transitions and animations between articles
    @reuse 'article-layout', ArticleShowLayoutView,
      region: 'content'
      model: mediator.categories.get ~~categoryId

    @view = new ArticleShowView
      region: 'article'
      model: model
      pager: articles