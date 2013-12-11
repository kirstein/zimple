if typeof document isnt 'undefined'
  window.Benchmark = require 'benchmark'

__suites = []
global.registerSuite = (suite, options) ->
  __suites.push suite : suite, options : options
  suite

# Expose Z
Z = require '../../lib/src/zimple'
