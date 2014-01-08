module.exports = (suites, Benchmark, Z, underscore, lodash) ->
  suites.push suite = new Benchmark.Suite

  reduceArr    = [ 2, 5, 9 ]
  reduceFn     = (a,b) -> a + b
  reduce_first = 'what-is-this'

  # Z performance
  suite.add 'Z.reduce array',                     -> Z.reduce reduceArr, reduceFn
  suite.add 'Z.reduce array first arg',           -> Z.reduce reduceArr, reduceFn, reduce_first
  suite.add 'Z.reduce array (wrapped)',           -> Z(reduceArr).reduce reduceFn
  suite.add 'Z.reduce array first arg (wrapped)', -> Z(reduceArr).reduce reduceFn, reduce_first

  # Underscore perf
  suite.add 'underscore.reduce array',                     -> underscore.reduce reduceArr, reduceFn
  suite.add 'underscore.reduce array first arg',           -> underscore.reduce reduceArr, reduceFn, reduce_first
  suite.add 'underscore.reduce array (wrapped)',           -> underscore(reduceArr).reduce reduceFn
  suite.add 'underscore.reduce array first arg (wrapped)', -> underscore(reduceArr).reduce reduceFn, reduce_first

  # Lodash perf
  suite.add 'lodash.reduce array',           -> lodash.reduce reduceArr, reduceFn
  suite.add 'lodash.reduce array first arg', -> lodash.reduce reduceArr, reduceFn, reduce_first
