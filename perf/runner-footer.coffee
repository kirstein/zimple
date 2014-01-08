fs   = require 'fs'
path = require 'path'

# Expose libraries
# We are exposing them to global scope to make perfs easier
global.Z          = require '../src/zimple'
global.lodash     = require 'lodash'
global.underscore = require 'underscore'

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
      require(fname) runner.suites

# Initialize dir
readdir process.cwd()

if typeof document isnt 'undefined'
  window.__runTests = start
else
  require('microtime')
  #runner.run()
