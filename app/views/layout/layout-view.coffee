module.exports = class LayoutView extends Layout
  container: 'body'
  regions:
    content: '#content'
    'tab-pager': '.tab-pager'

  events:
    'click .icon-settings': 'toogleDebug'

  ##
  # DEBUG STUFF

  debugHelloWord: (callback)->
    callback 'Hello Word!'

  debugNumberOfArticles: (callback)->
    callback mediator.articles.length

  # Debug handler: make a little black window appear at the top of the screen
  toogleDebug: ->
    unless ($debug = @$('.debug')).is ':hidden'
      @$('.icon-settings').removeClass 'active'
      return $debug.velocity('transition.slideUpBigOut')

    debugs = _(_.functions(@)).filter (n)-> _(n).startsWith 'debug'

    endCallback = _.after debugs.length, =>
      @$('.icon-settings').addClass 'active'
      $debug.velocity 'transition.slideDownBigIn'

    $debug.html('')

    callback = (name) -> (content)->
      $p = $('<div/>').addClass('row').appendTo $debug
      $('<strong/>').addClass('col-xs-2').text("#{name}: ").appendTo $p
      $('<span/>').addClass('col-xs-10').text(content or '<null>').appendTo $p
      endCallback()


    @[debug](callback(debug.replace('debug', ''))) for debug in debugs
    @