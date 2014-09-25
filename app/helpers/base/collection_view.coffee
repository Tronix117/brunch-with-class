module.exports = class CollectionView extends Chapeau.CollectionView
  
  constructor: (options)->
    _.extend @, _.pick options or {}, ['pager']
    super