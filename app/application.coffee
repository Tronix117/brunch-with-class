module.exports = class Application extends Chapeau.Application
  title: ''
  options:
    routes: require 'routes'



  # # Prestart can be used to defer the start of the application
  # # It can be useful if you want to fetch some infos from the API before
  # # anything.
  # beforeStart: (start)->
  #   super