##
# Additions:
# * `timestamps: true` on a model has the same behavior than in rails
#   it automatically handle the `created_at` and the `updated_at` column

module.exports = class Model extends Chaplin.Model
  # Mixin a synchronization state machine
  _(@prototype).extend Chaplin.SyncMachine

  initialize: ->
    @url = config.api.endpoint + '/' + @path
    super
    if @timestamps and @isNew()
      @set {'created_at': d = new Date(),  'updated_at': d}, silent: true
  
  save: ->
    @set {updated_at: new Date()}, silent: true if @timestamps
    super