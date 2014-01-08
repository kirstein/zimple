module.exports = (suites, Benchmark, Z, underscore, lodash) ->
  suites.push suite = new Benchmark.Suite

  invokeArray = [ 2, 5, 9 ]
  invokeFn    = 'toString'

  # Z performance
  suite.add 'Z.invoke array',                     -> Z.invoke invokeArray, invokeFn
  suite.add 'Z.invoke array oneparam',            -> Z.invoke invokeArray, invokeFn, 2
  suite.add 'Z.invoke array sixparams',           -> Z.invoke invokeArray, invokeFn, 2,4,5,6,7,8
  suite.add 'Z.invoke array (wrapped)',           -> Z(invokeArray).invoke invokeFn
  suite.add 'Z.invoke array oneparam (wrapped)',  -> Z(invokeArray).invoke invokeFn, 2
  suite.add 'Z.invoke array sixparams (wrapped)', -> Z(invokeArray).invoke invokeFn, 2,4,5,6,7,8

  # Underscore perf
  suite.add 'underscore.invoke array',                     -> underscore.invoke invokeArray, invokeFn
  suite.add 'underscore.invoke array oneparam',            -> underscore.invoke invokeArray, invokeFn, 2
  suite.add 'underscore.invoke array sixparams',           -> underscore.invoke invokeArray, invokeFn, 2,4,5,6,7,8
  suite.add 'underscore.invoke array (wrapped)',           -> underscore(invokeArray).invoke invokeFn
  suite.add 'underscore.invoke array oneparam (wrapped)',  -> underscore(invokeArray).invoke invokeFn, 2
  suite.add 'underscore.invoke array sixparams (wrapped)', -> underscore(invokeArray).invoke invokeFn, 2,4,5,6,7,8

  # Lodash perf
  suite.add 'lodash.invoke array',           -> lodash.invoke invokeArray, invokeFn
  suite.add 'lodash.invoke array oneparam',  -> lodash.invoke invokeArray, invokeFn, 2
  suite.add 'lodash.invoke array sixparams', -> lodash.invoke invokeArray, invokeFn, 2,4,5,6,7,8
