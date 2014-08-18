module.exports = class NavPagerItemView extends View

  makeInactive: (transition = 'fadeOut')->
    @$('.active-tab').velocity 'transition.' + transition, 500

  makeActive: (transition = 'fadeIn')->
    @$('.active-tab').velocity 'transition.' + transition, 500

  getTemplateData: ->
    data = super
    if @model instanceof ArticleModel
      params = _.extend {}, mediator.lastRouteParams
      params.articleId = data.id
      data.uri = Chaplin.utils.reverse 'article#show', params
    data

  go: =>
    if @model instanceof ArticleModel
      mediator.smartNavigate articleId: @model.get 'id'