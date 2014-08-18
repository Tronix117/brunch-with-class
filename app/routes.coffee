module.exports = (match) ->
  match '', 'default#index'
  match 'index.html', 'default#index'

  match 'categories', 'category#index'
  match 'categories/:categoryId/articles', 'article#index', smart: true,
    constraints: categoryId: /^\d+$/
  match 'categories/:categoryId/articles/:articleId', 'article#show',
    smart: true, constraints: categoryId: /^\d+$/, articleId: /^\d+$/
  
  match 'articles', 'article#index'
  match 'articles/:articleId', 'article#show', smart: true, constraints:
    articleId: /^\d+$/

  match '*url', 'default#error'