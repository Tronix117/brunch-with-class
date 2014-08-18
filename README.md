# Brunch app

This is HTML5 application, built with [Brunch](http://brunch.io).

## Getting started
* Install node.js from the official website
* Install cairo for spritesheet generation (brew install cairo), you may install brew and xquartz before
* Install [Brunch](http://brunch.io): `npm install -g brunch`.
* Install Brunch plugins: `npm install`.
* Install [Bower](http://bower.io) components: `bower install` (if bower is not installed on your system, install it with `npm install -g bower`)
* Watch the project with continuous rebuild by
`brunch watch --server`. This will also launch HTTP server.
* Or build the minified project with `brunch build --optimize`.

Open the `public/` dir to see the result.

* Write your code in `app` dir.
* Put static files that should be copied (index.html etc) to `app/assets`.
* Manage dependencies with [Bower](http://bower.io) or simply put
  third-party styles & scripts in `vendor` dir.

## Coding

This skeleton has been made to increase productivity when developping

* No `require` of collection, view or template is needed, everything is preloaded
* `ArticleIndexView` will point to `views/article/index/index-view.coffee`

### Model/Collection

* Collection will try to find model with same name, `ArticleCollection`, will try to find `ArticleModel`
* `where` returns a Collection of the same type, check `backbone.collectionsubset` for more infos, this collection is also cached

### View organisation

* Styles, Templates and Views are all in the same place, in order to access them more efficiently and to keep organisation clean.
* No need to specify `@template` on View
* No need to specify `@listSelector` on CollectioView, default to `.list`
* No need to specify `@itemView` on View, it default to the `item/item-view` in the same folder
* `View::beforeTemplate(callback)` can be overrided and is executed before the view render, callback must be call to render
* `View::afterTemplate()` occurs after the render and can be overrided as well

Ex:
    /app
      /views
        /layout
          layout-view.coffee - LayoutView
          layout.jade - LayoutTemplate, the jade template 
          layout.styl - corresponding styl, should start with `.layout-view`
        /article
          /index
            index-view.coffee - ArticleIndexView, list of article (CollectionView)
            index.jade - ArticleTemplate, can be omitted if it's just a list of item
            index.styl
            /item
              item-view.coffee - ArticleIndexItemView, item (itemView of index-view.coffee)
              item.jade
              item.styl


### Animation and touch events

Animations are prefered to be in CSS, using velocity (with UI Pack):

    @$('.something').velocity 'transition.bouceIn', -> console.log 'done'


Touch events are handled by hammer, use `hammerEvents` instead of basic jQuery `events` :

    hammerEvents:
      'swipeLeft .element': 'onSwipeLeft'


### Smart Navigation

* To navigate within the app, use `<a>` element as often as you can
* No need to put `href`, it will be automaticaly added from some data arguments: data-route-name, data-route-reset, data-route-arg1, data-route-arg2, ...
* If parameters are already in the URL of the current page, they will be added as well, except if data-route-reset is passed
* Please also read helpers/smart-navigate.coffee


Ex for the current url: `/categories/2/articles/1`
    
    a(data-route-name='article#show', data-route-article-id=3)
    // -> <a href="/categories/2/articles/3">

    a(data-route-name='article#show', data-route-article-id=3, data-route-reset)
    // -> <a href="/articles/3">


### Debugging

Sometime it's not easy to test on devices without console, or sometime you want a quick info to some debug data
In the LayoutView, just add some method starting with `debug` like this: 

    debugSomething: (callback)->
      callback('Some value')

    debugSomethingElse: (callback)->
      callback('Some other value')

Then on the `layout` there is a small button, you can hit to have an area display on the screen with your debug datas like:

    Something:        Some value
    SomethingElse:    Some other value