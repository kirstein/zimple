fs    = require 'fs'
path  = require 'path'
spawn = require('child_process').spawn


# Expose libraries
# We are exposing them to global scope to make perfs easier
libs =
  lodash     : require 'lodash'
  underscore : require 'underscore'
  Bencmark   : require 'benchmark'

# Get options
opts = require('nomnom').parse()

# Start the test runner
runner = require('./suite') opts

# Get all files
readdir = (dir) ->
  regxp = new RegExp /.*\.perf\.coffee/
  files = fs.readdirSync dir
  files.forEach (file) ->
    fname = path.join dir, file
    stat  = fs.statSync fname
    isDir = stat.isDirectory()
    if isDir
      readdir fname
    else if regxp.test fname
      require(fname) runner.suites,
                     libs.Bencmark,
                     libs.Z,
                     libs.underscore,
                     libs.lodash

## Initialize dir
#readdir process.cwd()

if typeof document isnt 'undefined'
  window.__runTests = start
else
  require('microtime')
  build = spawn('grunt', [ 'build']);
  build.on 'close', (code) ->
    if code is 0
      console.log 'Built Z'
      libs.Z = require '../lib/src/zimple'
      readdir process.cwd()
      runner.run()
    else
      console.log 'Failed to build Z'

