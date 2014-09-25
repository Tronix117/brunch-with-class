window.global = global = window

global.config = require 'config'


$ ->
  Application = require 'application'
  # Mix in underscore.string into underscore
  _.mixin _.str.exports()

  # Initialize the application on DOM ready event.
  new Application