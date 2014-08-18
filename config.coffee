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
        no_trailing_semicolons:
          level: "ignore"
        no_trailing_whitespace:
          level: "warn"
        no_backticks:
          level: "warn"
        indentation:
          value: 2
          level: "error"
        max_line_length:
          value: 80
          level: "warn"

    # AutoReload should not be enabled in production
    autoReload:
      enabled: not production

    sprites:
      # Use sprite features.
      enabled: true

      # Directory in which to output sprite sheet images.
      outputDir: 'images/sprites',

      # File name of output sprite sheet images.
      # outputFile: '{{name}}.png',

      # Include provided `sprite` mixin when compiling Stylus.
      includeMixins: true

      # Sprite mixin will `@extend` a sprite sheet's styles, instead of
      # including them directly in the selector in which the mixin is used.
      # useExtendDirective: true,

      # Name of the default sprite sheet to use when one is not passed to the
      # provided Stylus mixin or functions.
      defaultSheet: 'default',

      # Sprite sheets to generate. The regular expression matches images to
      # include in that particular sprite sheet.
      spriteSheets:
        'default': /^app\/assets\/images\/_default\/(.*)\.png$/
        'ui': /^app\/assets\/images\/_ui\/(.*)\.png$/
        'visual': /^app\/assets\/images\/_visuals\/(.*)\.png$/

      # Engine Spritemith uses to generate images ('phantomjs', 'canvas', 'gm')
      # See https:#github.com/Ensighten/spritesmith for more information.
      engine: 'gm',

      # Image packing algoritm ('binary-tree', 'top-down', 'left-right', 'diagonal', 'alt-diagonal')
      algoritm: 'top-down'

      # Padding in pixels to add between sprite images
      # padding: 0

      # Options to pass through to engine for settings
      # exportOpts: 
        # Format of output sprite sheets ('png', 'jpeg'); Canvas and gm engines only
        # format: 'png'

        # Quality of output sprite sheets; gm engine only
        # quality: 75

        # Milliseconds to wait until terminating PhantomJS script; phantomjs engine only
        # timeout: 10000

      # Options to pass through to engine for export
      # engineOpts: {},