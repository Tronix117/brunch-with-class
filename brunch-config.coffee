sysPath = require 'path'

production = process.env.BRUNCH_ENV is 'production'

# See http://brunch.io/#documentation for docs.
exports.config =
  # Let's minify everything when production
  optimize: production

  # Like to get notifications if available
  notifications: true

  # Where to make the magic !
  #paths:
  #  public: 'public'

  files:
    javascripts:
      joinTo: 
        # Better two have app.js AND vendor.js for caching reasons (vendor is not updated as often)
        'js/app.js': /^(app)/
        'js/vendor.js': /^(vendor|bower_components)/
    stylesheets:
      joinTo:
        'css/app.css': /^(app)/
        'css/vendor.css': /^(vendor|bower_components)/
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