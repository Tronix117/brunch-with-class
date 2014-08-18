module.exports = class ArticleShowView extends View
  beforeDispose: (callback)->
    # app:article.dispose is handled by ArticleShowLayoutView for animations
    if mediator._events['app:article.dispose'].length > 0
      return mediator.publish 'app:article.dispose', @, callback

    callback()

  afterRender: ->
    # app:article.render is handled by ArticleShowLayoutView for animations
    mediator.publish 'app:article.render', @