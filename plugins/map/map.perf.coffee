Benchmark = require 'benchmark'
suite     = global.registerSuite new Benchmark.Suite

do ->
  mapFn = (val) -> val * 2
  mapArr = [ 2, 5, 9 ]

  suite.add 'map', ->
    Z.map mapArr, mapFn

  suite.add 'map thisArg', ->
    Z.map mapArr, mapFn, @

  suite.add 'map (wrapped) with new', ->
    new Z(mapArr).map mapFn

  suite.add 'map (wrapped)', ->
    Z(mapArr).map mapFn

  suite.add 'map thisArg (wrapped)', ->
    Z(mapArr).map mapFn, @
