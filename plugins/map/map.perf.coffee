Benchmark = require 'benchmark'
suite     = global.registerSuite new Benchmark.Suite

do ->
  mapFn = (val) -> val * 2
  mapArr = [ 2, 5, 9 ]

  # Z performance
  suite.add 'Z.map',                    -> Z.map mapArr, mapFn
  suite.add 'Z.map thisArg',            -> Z.map mapArr, mapFn, @
  suite.add 'Z.map (wrapped) with new', -> new Z(mapArr).map mapFn
  suite.add 'Z.map (wrapped)',          -> Z(mapArr).map mapFn
  suite.add 'Z.map thisArg (wrapped)',  -> Z(mapArr).map mapFn, @

  # Underscore perf
  suite.add 'underscore.map',                    -> underscore.map mapArr, mapFn
  suite.add 'underscore.map thisArg',            -> underscore.map mapArr, mapFn, @
  suite.add 'underscore.map (wrapped) with new', -> new underscore(mapArr).map mapFn
  suite.add 'underscore.map (wrapped)',          -> underscore(mapArr).map mapFn
  suite.add 'underscore.map thisArg (wrapped)',  -> underscore(mapArr).map mapFn, @

  # Lodash perf
  suite.add 'lodash.map',                    -> lodash.map mapArr, mapFn
  suite.add 'lodash.map thisArg',            -> lodash.map mapArr, mapFn, @
