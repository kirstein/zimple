Z = require '../src/zimple'

plugins = Z::__plugins
describe 'zimple #fn', ->
  afterEach -> Z::__plugins = plugins
  it 'should expose plugin', ->
    Z.fn 'fn_count', ->
    Z.fn_count.should.be.ok
    Z().fn_count.should.be.ok

  it 'should be able to redefine plugin', ->
    Z.fn 'fn_zzz', -> 'tere'
    Z.fn_zzz().should.eql 'tere'
    Z.fn 'fn_zzz', -> 'bye'
    Z.fn_zzz().should.eql 'bye'

  it 'should add options to the function if provided', ->
    Z.fn 'fn_zzz', ( -> ) , __test: 123
    Z::__plugins.fn_zzz.options.__test.should.eql 123

  it 'should be return Z after the function definition', ->
    Z.fn('fn_xxx', -> 'hello').should.eql Z

  describe 'throwing', ->
    it 'should throw if the given plugin has no function', ->
      (-> Z.fn 'fn_sum').should.throw 'No function defined for plugin \'fn_sum\''

    it 'should throw if the given plugin has no name', ->
      (-> Z.fn()).should.throw 'No plugin name defined'

  it 'should handle the same way with wrapping and without', ->
    Z.fn 'fn_sum', (arr) -> arr.reduce (old, val) -> old + val

    Z([1,2,3]).fn_sum().should.eql(6)
    Z.fn_sum([1,2,3]).should.eql(6)

  it 'should allow passing parameters to the plugin', ->
    Z.fn 'fn_param', (arr, parameter) -> parameter

    Z().fn_param('test').should.eql('test')
    Z.fn_param(null, 'test').should.eql('test')

  it 'should not pass extra params to arguments', ->
    Z.fn 'fn_paramguard', (context, args) -> throw new Error "did not expect any args #{args}" if args

    Z().fn_paramguard()
    Z.fn_paramguard()

  it 'should not mutate the context object directly', ->
    start = 0
    Z.fn 'fn_decrement', (context) -> --context

    Z(start).fn_decrement().should.eql -1
    Z.fn_decrement(start).should.eql -1
    start.should.eql 0

  it 'should work with function references', ->
    Z.fn 'fn_decrement', (context) -> context - 1

    dec = Z(123).fn_decrement
    dec().should.eql 122

  it 'should not trigger any plugins unless they are called', ->
    Z.fn 'fn_throwy'  , -> throw new Error 'should not have been called me'
    Z.fn 'fn_throwy2' , -> throw new Error 'should not have been called me'
    Z.fn 'fn_easy', -> 'fn_easy'

    Z.fn_easy().should.eql 'fn_easy'

