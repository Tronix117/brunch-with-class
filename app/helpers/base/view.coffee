module.exports = class View extends Chapeau.View
  
  constructor: (options)->
    _.extend @, _.pick options or {}, ['pager']
    super