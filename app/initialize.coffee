window.global = global = window

global.Application    = require 'application'
global.View           = require 'helpers/base/view'
global.Layout           = require 'helpers/base/layout'
global.Controller     = require 'helpers/base/controller'
global.Model          = require 'helpers/base/model'
global.Collection     = require 'helpers/base/collection'
global.CollectionView = require 'helpers/base/collection_view'
global.Store          = Backbone.LocalStorage

global.config = require 'config'

lastPartOfPath = (p)-> p.substr p.lastIndexOf('/') + 1

global.__t = (path)-> require "views/#{path}/#{lastPartOfPath path}"
global.__v = (path)-> require "views/#{path}/#{lastPartOfPath path}-view"
global.__m = (path)-> require "models/#{path}"
global.__c = (path)-> new require "collections/#{path}-collection"

$ ->
  # Mix in underscore.string into underscore
  _.mixin _.str.exports()

  _.mixin
    functionName: (f)->
      ret = f.toString().substr(9) #'function '.length
      ret.substr(0, ret.indexOf('('))
    className: (c)->
      ret = c.constructor.toString().substr(9) #'function '.length
      ret.substr(0, ret.indexOf('('))

  global._orderedRequireList =
    views: []
    collections: []
    models: []
    helpers: []
    templates: []
    controllers: []
    misc: []

  for r in global.require.list()
    topDir = r.split('/')[0]
    if _orderedRequireList[topDir]
      if topDir is 'views' and not _.endsWith r, '-view'
        _orderedRequireList.templates.push r
      else
        _orderedRequireList[topDir].push r
    else
      _orderedRequireList.misc.push r

  # Fix for views, collection view must be loaded after views, and usualy path
  # of subviews is `collectionview-name/subitem` which need to be loaded before
  # `collectionview-name`, a sort to have the longer path first should be enough
  _orderedRequireList.views = _orderedRequireList.views.sort (a,b)->
    b.split('/').length - a.split('/').length

  preload = (type)->
    for r in _orderedRequireList[type]
      dirs = r.split '/'
      dirs.shift()

      if (type is 'views' or type is 'templates' or type is 'controllers') and
      dirs[dirs.length - 2] is dirs[dirs.length - 1].replace('-view', '')
        dirs[dirs.length - 2] = ''
      
      d = dirs.join('-')

      switch type
        when 'views', 'collections'
          name = _.classify d
        else
          name = _.classify "#{d}-#{type.slice 0, -1}"

      # console.log name, r
      global[name] = require r
    return

  preload 'helpers'
  preload 'models'
  preload 'collections'
  preload 'templates'
  preload 'views'
  #preload 'controllers'

  #require 'helpers/smart-navigate'

  # Initialize the application on DOM ready event.
  new Application