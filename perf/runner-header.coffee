if typeof document isnt 'undefined'
  window.Benchmark = require 'benchmark'
else
  require 'microtime'

__suites = []
global.registerSuite = (suite, options) ->
  __suites.push suite : suite, options : options
  suite

# Expose Z
global.Z          = require '../../lib/src/zimple'
global.lodash     = require 'lodash'
global.underscore = require 'underscore'

