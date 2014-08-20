module.exports = class Controller extends Chaplin.Controller

  beforeAction: (params, route)->
    log "[c='font-size: 1.2em;color:#d33682;font-weight:bold']\
▚ #{route.name}[c]\t\t", route
    super