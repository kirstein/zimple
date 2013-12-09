module.exports = (grunt) ->

  # Require all grunt plugins at once
  require('load-grunt-tasks')(grunt)

  # Path configrations
  LIB_PATH    = 'lib'
  SRC_PATH    = 'src'
  TEST_PATH   = 'test'
  PLUGIN_PATH = 'plugins'

  ###
  # tasks
  ###
  grunt.registerTask 'build', [ 'clean', 'coffee' ]
  grunt.registerTask 'test', [ 'build', 'mochacov:spec' ]
  grunt.registerTask 'cov',  [ 'build', 'mochacov:cov' ]
  grunt.registerTask 'travis', [ 'build', 'mochacov:travis' ]
  grunt.registerTask 'release', [ 'build', 'test', 'wrap', 'uglify' ]
  grunt.registerTask 'default', [ 'test' ]

  ###
  # config
  ###
  grunt.initConfig

    # Clean the lib folder
    clean:
      lib : [ LIB_PATH ]

    wrap :
      production:
        src     : "#{LIB_PATH}/src/zimple.js"
        dest    : 'zimple.js'
        options :
          wrapper : ['(function(global, undefined) {', '})(this);']

    coffee:
      build :
        options :
          # Do not wrap it in self executing fn
          bare : true
        files : 'lib/src/zimple.js' : [ "#{SRC_PATH}/**/*.coffee", "#{PLUGIN_PATH}/**/*.coffee", "!#{PLUGIN_PATH}/**/*.test.coffee" ]
      test:
        src     : [ TEST_PATH, PLUGIN_PATH ].map (path) -> "#{path}/**/*.test.coffee"
        dest    : LIB_PATH
        expand  : true
        rename  : (dest, src) ->
          "#{dest}/" + src.replace /\.coffee$/, '.js'

    uglify :
      build:
        options:
          report :'gzip'
        files  :
          'zimple.min.js' : [ 'zimple.js' ]


    mochacov :
      travis :
        coveralls : serviceName : 'travis-ci'
      spec :
        options : reporter : 'spec'
      cov  :
        options : reporter : 'html-cov'
      options :
        files    : [ "#{LIB_PATH}/**/*.test.js" ]
        require  : [ 'should' ]
        growl    : true
        ui       : 'tdd'

    # Watch for file changes.
    watch:
      lib:
        files : [ '**/*.coffee' ]
        tasks : [ 'clean', 'coffee', 'test' ]
        options :
          nospawn : true
