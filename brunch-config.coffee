sysPath = require 'path'

production = process.env.BRUNCH_ENV is 'production'

# See http://brunch.io/#documentation for docs.
exports.config =
  # Let's minify everything when production
  optimize: production

  # Configuration for npm

  npm:
    globals: 
      Backbone: 'backbone'
      jQuery: 'jquery'
      $: 'jquery'
      underscore: 'lodash'
      lodash: 'lodash'
      _: 'lodash'
      log: 'log-with-style'
      'underscore.string': 'underscore.string'
      'Hammer': 'hammerjs'
      'backbone.hammer': 'backbone.hammer'
      'backbone.collectionsubset': 'backbone.collectionsubset'
      'velocity': 'velocity-animate'
      # Chaplin: 'chaplin'
      # Chapeau: 'chapeau'
    static: ['node_modules/chaplin/chaplin.js', 'node_modules/chapeau/build/chapeau.js']

  # Like to get notifications if available
  notifications: true

  # Where to make the magic !
  #paths:
  #  public: 'public'

  modules:
    nameCleaner: (path)->
      # Remove file extension added after brunch v2
      path = path.substr(0, path.lastIndexOf('.')) or path
      path.replace(/^app\//, '')

  files:
    javascripts:
      joinTo: 
        # Better two have app.js AND vendor.js for caching reasons (vendor is not updated as often)
        'js/app.js': /^(app)/
        'js/vendor.js': /^(vendor|node_modules)/
      order:
        before: /^node_modules\/(jquery)/
        after: /^node_modules\/(chapeau)/
    stylesheets:
      joinTo:
        'css/app.css': /^(app)/
        'css/vendor.css': /^(vendor|node_modules)/
      order:
        before: /^app(\/|\\)styles/
    templates: 
      joinTo: 'js/app.js'

  conventions:
    # Ignore files finishing by .dev.* or .prod.* depending on the env
    # Ignore files with filename starting by `_` or in a (sub)directory
    # with name starting by `_`
    ignored: (path) ->
      (basename = sysPath.basename path)[0] is '_' or
      /(^|\/)_.*/.test(sysPath.dirname path) or
      (production and /.*\.dev\..*$/ or /.*\.prod\..*$/).test(basename)
    assets: /(assets|font)/

  plugins:
    jaded: 
      staticPatterns: [
        /^app(\/|\\)views(\/|\\)(.+)\.static\.dev\.jade$/
        /^app(\/|\\)views(\/|\\)(.+)\.static\.prod\.jade$/
        /^app(\/|\\)views(\/|\\)(.+)\.static\.jade$/
      ]
      jade:
        pretty: not production
        compileDebug: not production

    # Little hack to fix some issues stylus have with size of images
    stylus:
      paths: ['app/assets/images']
      imports: ['nib', 'app/styles/_theme/index']

    # Some conventions to keep code clean
    coffeelint:
      pattern: /^app\/.*\.coffee$/
      options:
        no_trailing_whitespace:
          level: "warn"
        no_interpolation_in_single_quotes:
          level: "error"
        no_backticks:
          level: "warn"
        no_empty_param_list:
          level: "warn"
        indentation:
          value: 2
          level: "error"
        max_line_length:
          value: 80
          level: "warn"
        colon_assignment_spacing:
          spacing :
            left: 0
            right: 1
          level: "warn"
        prefer_english_operator:
          level: "warn"

    # AutoReload should not be enabled in production
    autoReload:
      enabled: not production