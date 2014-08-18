module.exports = class ArticleShowLayoutView extends View
  regions:
    article: 'article'
  listen:
    'app:article.dispose mediator': 'onArticleDispose'
    'app:article.render mediator': 'onArticleRender'
  hammerEvents:
    #'swipeLeft .article': 'onSwipeLeft'
    #'swiperight .article': 'onSwipeRight'
    'dragend article': 'onDragEnd'
    'drag article': 'onDrag'
  hammerOptions: {}


  onArticleDispose: (view, callback)->
    @$('article').velocity 'transition.slideLeftBigOut', callback

  onArticleRender: (view)->
    @$('article').velocity 'transition.slideRightBigIn'

  onNavRightAction:(e)->
    e.preventDefault()
    mediator.publish 'pager:next'

  onSwipeLeft: ->
    mediator.publish 'pager:previous'

  onSwipeRight: ->
    mediator.publish 'pager:next'

  onDrag: (ev)->
    s = if ev.gesture.direction is 'left' then '-' else ''
    @$('article').velocity translateX: s + ev.gesture.distance + 'px', 0

  onDragEnd: (ev)->
    if ev.gesture.distance < 100
      return @$('article').velocity translateX: 0

    if ev.gesture.direction is 'left'
      mediator.publish 'pager:next'
    else
      mediator.publish 'pager:previous'