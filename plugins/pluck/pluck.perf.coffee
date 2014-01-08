module.exports = (suites, Benchmark, Z, underscore, lodash) ->
  suites.push suite = new Benchmark.Suite

  # Test data
  key      = 'test'
  pluckArr = [ 2, 5, 9 ]
  pluckObj = asd : 123
  pluckStr = 'what-is-this'

  # Z performance
  suite.add 'Z.pluck array',            -> Z.pluck pluckArr, key
  suite.add 'Z.pluck null',             -> Z.pluck null, key
  suite.add 'Z.pluck object',           -> Z.pluck pluckObj, key
  suite.add 'Z.pluck string',           -> Z.pluck pluckStr, key
  suite.add 'Z.pluck string (wrapped)', -> Z(pluckStr).pluck key
  suite.add 'Z.pluck null (wrapped)',   -> Z(null).pluck key
  suite.add 'Z.pluck array (wrapped)',  -> Z(pluckArr).pluck key
  suite.add 'Z.pluck object (wrapped)', -> Z(pluckObj).pluck key

  # Underscore perf
  suite.add 'underscore.pluck array',            -> underscore.pluck pluckArr, key
  suite.add 'underscore.pluck null',             -> underscore.pluck null, key
  suite.add 'underscore.pluck object',           -> underscore.pluck pluckObj, key
  suite.add 'underscore.pluck string',           -> underscore.pluck pluckStr, key
  suite.add 'underscore.pluck string (wrapped)', -> underscore(pluckStr).pluck key
  suite.add 'underscore.pluck null (wrapped)',   -> underscore(null).pluck key
  suite.add 'underscore.pluck array (wrapped)',  -> underscore(pluckArr).pluck key
  suite.add 'underscore.pluck object (wrapped)', -> underscore(pluckObj).pluck key

  # Lodash perf
  suite.add 'lodash.pluck array',  -> lodash.pluck pluckArr, key
  suite.add 'lodash.pluck null',   -> lodash.pluck null, key
  suite.add 'lodash.pluck object', -> lodash.pluck pluckObj, key
  suite.add 'lodash.pluck string', -> lodash.pluck pluckStr, key
