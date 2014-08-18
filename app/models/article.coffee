module.exports = class ArticleModel extends Model
  constructor: ->
    @on 'change:content', (m, v)-> @set 'catch_phrase', _(v).prune 50
    super