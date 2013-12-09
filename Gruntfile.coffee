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
  grunt.registerTask 'test', [ 'mochacli' ]
  grunt.registerTask 'build', [ 'clean', 'coffee', 'test', 'wrap', 'uglify' ]
  grunt.registerTask 'default', [ 'build' ]

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


    # For testing we run all the plugin tests
    # and all the standalone tests
    mochacli:
      all : [ "#{LIB_PATH}/**/*.test.js" ]
      options :
        require  : [ 'should' ]
        growl    : true
        reporter : 'spec'
        ui       : 'tdd'

    # Watch for file changes.
    watch:
      lib:
        files : [ '**/*.coffee' ]
        tasks : [ 'clean', 'coffee', 'test' ]
        options :
          nospawn : true
