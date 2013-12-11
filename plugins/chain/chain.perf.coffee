Benchmark = require 'benchmark'
suite     = global.registerSuite new Benchmark.Suite

do ->
  Z.fn 'chainTest', -> arguments.length
  arr = [1,2,4]

  suite.add 'chain creation', ->
    Z.chain arr

  suite.add 'chain creation wrapped', ->
    Z(arr).chain()

  suite.add 'chain link value', ->
    Z.chain(arr).chainTest().value()

  suite.add 'chain link value wrapped', ->
    Z(arr).chain().chainTest().value()
