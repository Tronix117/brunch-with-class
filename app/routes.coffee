module.exports = (match) ->

  match 'categories', 'category#index'

  match 'categories/:categoryId/articles', 'article#index',
    smart: true,
    constraints: categoryId: /^\d+$/

  match 'categories/:categoryId/articles/:articleId', 'article#show',
    smart: true
    constraints: categoryId: /^\d+$/
    articleId: /^\d+$/
  
  match 'articles', 'article#index'

  match 'articles/:articleId', 'article#show', 
    smart: true
    constraints: articleId: /^\d+$/


  match '', 'default#index'
  match 'index.html', 'default#index'
  match '*url', 'default#error'