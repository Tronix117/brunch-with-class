module.exports = class NavPagerView extends CollectionView
  template: null
  listen:
    'dispatcher:dispatch mediator': 'onDispatch'
    'pager:next mediator': 'onNext'
    'pager:previous mediator': 'onPrevious'

  activeView: null
  activeIndex: null
  activeRouteName: null
  previousCollection: null

  onDispatch: (controller, params, route, options)->
    return @hide() unless view = controller.view
    return @hide() unless opts = view.pager

    model = view.model

    @collection = opts.collection or opts

    return @hide() unless @collection and model and
    model instanceof @collection.model

    @render() if @collection isnt @previousCollection
    @previousCollection = @collection

    @show()

    index = @collection.indexOf model

    dirOut = if index > @activeIndex then 'slideRightOut' else 'slideLeftOut'
    dirIn = if index > @activeIndex then 'slideLeftIn' else 'slideRightIn'

    @activeView.makeInactive dirOut if @activeView

    @activeView = @subviews[index]
    @activeIndex = index
    @activeRouteName = route

    @activeView and @activeView.makeActive dirIn

  hide: ->
    @$el.velocity('transition.fadeOut') unless @$el.is ':hidden'

  show: ->
    @$el.velocity('transition.fadeIn') if @$el.is ':hidden'

  onNext: ->
    newIndex = 0 if (newIndex = @activeIndex + 1) >= @collection.length
    @subviews[newIndex].go()

  onPrevious: ->
    newIndex = @collection.length - 1  if (newIndex = @activeIndex - 1) < 0
    @subviews[newIndex].go()
