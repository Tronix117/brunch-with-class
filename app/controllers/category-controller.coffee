module.exports = class CategoryController extends AbstractAppController

  index: (params, route)->
    @view = new CategoryView
      region: 'content'
      collection: mediator.categories