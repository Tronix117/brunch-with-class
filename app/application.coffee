global.mediator = require 'mediator'

module.exports = class Application extends Chaplin.Application
  title: ''
  options:
    routes: require 'routes'
    controllerSuffix: '-controller'

  constructor: (options) ->
    _.extend(@options, options)

    super @options

  initMediator: ->
    # Declare additional properties for mediator bellow

    mediator.articles = new ArticleCollection
    mediator.categories = new CategoryCollection

    # Seal the mediator
    super

  start: ->
    super