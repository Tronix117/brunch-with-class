module.exports = class Layout extends Chaplin.Layout
  getTemplateFunction: View::getTemplateFunction
  render: View::render
  enhance: View::enhance
  beforeRender: View::beforeRender

  constructor: (options)->
    @_className = _.className(@)
    super

  # Hotfix for single app page on windows
  isExternalLink: (link) ->
    link.target is '_blank' or
    link.rel is 'external' or
    link.protocol not in ['https:', 'http:', ':', 'file:', location.protocol] or
    link.hostname not in [location.hostname, '']

  openLink: (e)-> return