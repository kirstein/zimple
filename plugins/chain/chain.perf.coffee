module.exports = (suites, Benchmark, Z, underscore, lodash) ->
  suites.push suite     = new Benchmark.Suite
  suites.push linkSuite = new Benchmark.Suite

  arr   = [1,2,4]

  # Chain creation
  suite.add 'Z.chain creation',                  -> Z.chain arr
  suite.add 'Z.chain creation wrapped',          -> Z(arr).chain()
  suite.add 'underscore.chain creation',         -> underscore.chain arr
  suite.add 'underscore.chain creation wrapped', -> underscore(arr).chain()
  suite.add 'lodash.chain creation',             -> lodash.chain arr
  suite.add 'lodash.chain creation wrapped',     -> lodash(arr).chain()

  linkArr = [ 2, 5, 9 ]
  mapFn   = (val) -> val*2

  # Chain from start to finish
  linkSuite.add 'Z.chain link value',                  -> Z.chain(linkArr).map(mapFn).value()
  linkSuite.add 'Z.chain link value wrapped',          -> Z(linkArr).chain().map(mapFn).value()
  linkSuite.add 'underscore.chain link value',         -> underscore.chain(linkArr).map(mapFn).value()
  linkSuite.add 'underscore.chain link value wrapped', -> underscore(linkArr).chain().map(mapFn).value()
  linkSuite.add 'lodash.chain link value',             -> lodash.chain(linkArr).map(mapFn).value()
  linkSuite.add 'lodash.chain link value wrapped',     -> lodash(linkArr).chain().map(mapFn).value()

