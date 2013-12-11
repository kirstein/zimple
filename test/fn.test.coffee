Z = require '../src/zimple'

describe 'zimple #fn', ->
  it 'should expose plugin', ->
    Z.fn 'count', ->
    Z.count.should.be.ok
    Z().count.should.be.ok

  it 'should be able to redefine plugin', ->
    Z.fn 'zzz', -> 'tere'
    Z.zzz().should.eql 'tere'
    Z.fn 'zzz', -> 'bye'
    Z.zzz().should.eql 'bye'

  it 'should add options to the function if provided', ->
    Z.fn 'zzz', ( -> ) , __test: 123
    Z::__plugins.zzz.options.__test.should.eql 123

  it 'should be return Z after the function definition', ->
    Z.fn('xxx', -> 'hello').should.eql Z

  describe 'throwing', ->
    it 'should throw if the given plugin has no function', ->
      (-> Z.fn 'sum').should.throw 'No function defined for plugin \'sum\''

    it 'should throw if the given plugin has no name', ->
      (-> Z.fn()).should.throw 'No plugin name defined'

  it 'should handle the same way with wrapping and without', ->
    Z.fn 'sum', (arr) -> arr.reduce (old, val) -> old + val

    Z([1,2,3]).sum().should.eql(6)
    Z.sum([1,2,3]).should.eql(6)

  it 'should allow passing parameters to the plugin', ->
    Z.fn 'param', (arr, parameter) -> parameter

    Z().param('test').should.eql('test')
    Z.param(null, 'test').should.eql('test')

  it 'should not pass extra params to arguments', ->
    Z.fn 'paramguard', (context, args) -> throw new Error "did not expect any args #{args}" if args

    Z().paramguard()
    Z.paramguard()

  it 'should not mutate the context object directly', ->
    start = 0
    Z.fn 'decrement', (context) -> --context

    Z(start).decrement().should.eql -1
    Z.decrement(start).should.eql -1
    start.should.eql 0

  it 'should work with function references', ->
    Z.fn 'decrement', (context) -> context - 1

    dec = Z(123).decrement
    dec().should.eql 122

  it 'should not trigger any plugins unless they are called', ->
    Z.fn 'throwy'  , -> throw new Error 'should not have been called me'
    Z.fn 'throwy2' , -> throw new Error 'should not have been called me'
    Z.fn 'easy', -> 'easy'

    Z.easy().should.eql 'easy'

