Benchmark  = require 'benchmark'

do ->
  suite = global.registerSuite new Benchmark.Suite
  arr   = [1,2,4]

  # Chain creation
  suite.add 'Z.chain creation',                  -> Z.chain arr
  suite.add 'Z.chain creation wrapped',          -> Z(arr).chain()
  suite.add 'underscore.chain creation',         -> underscore.chain arr
  suite.add 'underscore.chain creation wrapped', -> underscore(arr).chain()
  suite.add 'lodash.chain creation',             -> lodash.chain arr
  suite.add 'lodash.chain creation wrapped',     -> lodash(arr).chain()

do ->
  suite = global.registerSuite new Benchmark.Suite
  arr   = [ 2, 5, 9 ]
  mapFn = (val) -> val*2

  # Chain from start to finish
  suite.add 'Z.chain link value',                  -> Z.chain(arr).map(mapFn).value()
  suite.add 'Z.chain link value wrapped',          -> Z(arr).chain().map(mapFn).value()
  suite.add 'underscore.chain link value',         -> underscore.chain(arr).map(mapFn).value()
  suite.add 'underscore.chain link value wrapped', -> underscore(arr).chain().map(mapFn).value()
  suite.add 'lodash.chain link value',             -> lodash.chain(arr).map(mapFn).value()
  suite.add 'lodash.chain link value wrapped',     -> lodash(arr).chain().map(mapFn).value()

