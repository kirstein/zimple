Benchmark = require 'benchmark'
suite     = global.registerSuite new Benchmark.Suite

do ->
  arr     = [ 2, 5, 9 ]
  fn      = (val) -> val % 2
  thisArg = @

  # Z performance
  suite.add 'Z.filter array',                   -> Z.filter arr, fn
  suite.add 'Z.filter array thisArg',           -> Z.filter arr, fn, thisArg
  suite.add 'Z.filter array (wrapped)',         -> Z(arr).filter fn
  suite.add 'Z.filter array thisArg (wrapped)', -> Z(arr).filter fn, thisArg

  # Underscore perf
  suite.add 'underscore.filter array',                   -> underscore.filter arr, fn
  suite.add 'underscore.filter array thisArg',           -> underscore.filter arr, fn, thisArg
  suite.add 'underscore.filter array (wrapped)',         -> underscore(arr).filter fn
  suite.add 'underscore.filter array thisArg (wrapped)', -> underscore(arr).filter fn, thisArg

  # Lodash perf
  suite.add 'lodash.filter array',         -> lodash.filter arr, fn
  suite.add 'lodash.filter array thisArg', -> lodash.filter arr, fn, thisArg
