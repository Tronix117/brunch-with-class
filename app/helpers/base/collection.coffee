module.exports = class Collection extends Chaplin.Collection
  # Mixin a synchronization state machine
  _(@prototype).extend Chaplin.SyncMachine

  # Use the project base model per default, not Chaplin.Model
  model: null

  subset: {}

  constructor: ->
    @_className = _.className(@).replace 'Collection', ''
    @model = global[@_className + 'Model'] or Model unless @model
    super

  initialize: ->
    d = _.dasherize @_className.charAt(0).toLowerCase() + @_className.slice(1)
    @url = config.api.endpoint + '/' + d + '/'

    #@localStorage = new Backbone.LocalStorage(_className)

    super

  # Subfilter is same as filter but return a subcollection instead of an Array
  subfilter: (f)-> @subcollection filter: f
  
  # Override where, so that it returns a subcollection instead of an Array
  where: (attrs, first)->
    cacheKey = 'where:' + JSON.stringify(attrs)
    return (if first then undefined else []) if _.isEmpty attrs
    @subset[cacheKey] or
    @subset[cacheKey] = @[if first then 'find' else 'subfilter'] (model)->
      for key of attrs
        return false if attrs[key] isnt model.get key
      true