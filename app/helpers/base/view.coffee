module.exports = class View extends Chaplin.View
  autoRender: yes

  ## Precompiled templates function initializer.
  getTemplateFunction: ->
    return @template if @template
    if _.endsWith @_className, 'View'
      return global[@_className.replace /View$/, 'Template']

  initAttributes: ->
    d = _.dasherize @_className.charAt(0).toLowerCase() + @_className.slice(1)
    @className = unless @className then d else @className + ' ' + d

  constructor: (options)->
    @_className = _.className(@)

    @initAttributes()
    #@initSelectors()

    @pager = options?.pager

    super

  beforeDispose: (callback) -> callback()
  beforeRender: (callback) -> callback()

  dispose: ->
    log "[c='font-weight:bold;margin-left:20px;color:#268bd2;']\
❖ #{@_className}::[c][c='font-weight:bold;color:#b58900']\
dispose[c]\t\t", @
    @beforeDispose => super

  render: ->
    log "[c='font-weight:bold;margin-left:20px;color:#268bd2;']\
❖ #{@_className}::[c][c='font-weight:bold;color:#b58900']\
render[c]\t\t", @

    @beforeRender =>
      super
      @enhance()
      @afterRender?()

  enhance: ->
    @$('a[data-route-name]').each ->
      @$ = $ @

      # We use previous parameters except if we have a data-route-reset
      routeParams = if @$.is('[data-route-reset]') then {}
      else _.extend {}, mediator.lastRouteParams

      routeName = null

      for k, v of @$.data()
        if k is 'routeName'
          routeName = v
        else if k isnt 'routeReset' and 0 is k.indexOf 'route'
          routeParams[(k = k.substr 5).charAt(0).toLowerCase() + k.slice 1] = v

      uri = '#'
      try uri = Chaplin.utils.reverse routeName, routeParams

      @$.attr 'href', uri

  # initSelectors: ->
  #   for element, selector of @elements then do (element, selector) =>
  #     this["$#{element}"] = (subSelector) =>
  #       $el = @$ selector
  #       $el = $el.find subSelector if subSelector
  #       $el

  # redirectTo: (url, options = {}) ->
  #   @publishEvent '!router:route', url, options, (routed) ->
  #     throw new Error 'View#redirectTo: no route matched' unless routed

  # delegateEvents: (events, keepOld) ->
  # super
  # @delegateHammerEvents()