window.global = global = window

global.config = require 'config'


$ ->
  window.Controller = require 'helpers/base/controller'
  window.CollectionView = require 'helpers/base/collection_view'
  window.Collection = require 'helpers/base/collection'
  window.Layout = require 'helpers/base/layout'
  window.View = require 'helpers/base/view'
  window.Model = require 'helpers/base/model'

  Application = require 'application'
  # Mix in underscore.string into underscore
  _.mixin _.str.exports()

  # Initialize the application on DOM ready event.
  new Application