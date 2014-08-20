module.exports = class CollectionView extends Chaplin.CollectionView
  # This class doesn’t inherit from the application-specific View class,
  # so we need to borrow the methods from the View prototype:
  getTemplateFunction: View::getTemplateFunction
  initAttributes: View::initAttributes
  beforeRender: View::beforeRender
  beforeDispose: View::beforeDispose
  #initSelectors: View::initSelectors
  #redirectTo: View::redirectTo
  useCssAnimation: true
  enhance: View::enhance

  constructor: (options)->
    @_className = _.className(@)

    # Pre-complete @itemView and @listSelector
    @itemView = global[@_className.replace 'View', 'ItemView'] unless @itemView
    if not @listSelector and global[@_className.replace /View$/, 'Template']
      @listSelector = '.list'

    @initAttributes()
    #@initSelectors()

    @pager = options?.pager

    super

  getTemplateData: ->
    # Add back model support to Chaplin
    templateData = super

    if @model
      # Erase model serialized with original templateData which include length
      # and synced flag
      templateData = _.extend Chaplin.utils.serialize @model, templateData

      # force synced flag to false if model is not in sync
      if typeof @model.isSynced is 'function' and not @model.isSynced()
        templateData.synced = false

    templateData

  dispose: ->
    log "[c='font-weight:bold;margin-left:20px;color:#268bd2;']\
❖ #{@_className}::[c][c='font-weight:bold;color:#b58900']\
dispose[c]\t\t", @
    @beforeDispose => super

  render: ->
    log "[c='font-weight:bold;margin-left:20px;color:#268bd2;']\
❖ #{@_className}::[c][c='font-weight:bold;color:#b58900']\
render[c]\t\t", @

    @beforeRender =>
      super
      @enhance()
      @afterRender?()