Z = require '../src/zimple'

describe 'zimple #fn', ->
  it 'should expose plugin', ->
    Z.fn 'count', ->
    Z.count.should.be.ok
    Z().count.should.be.ok

  it 'should add options to the function if provided', ->
    Z.fn 'zzz', ( -> ) , test: 123
    Z().zzz.test.should.eql 123
    Z.zzz.test.should.eql 123

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

  it 'should have context of Z', ->
    Z.fn 'param', (arr, parameter) -> @

    Z().param().should.be.instanceOf Z
    Z.param().should.be.instanceOf Z

  it 'should keep the Z context even when its called with different context', ->
    Z.fn 'param', (arr, parameter) -> @

    Z().param.call('yolo').should.be.instanceOf Z
    Z.param.call('yolo').should.be.instanceOf Z

  it 'should re-initiate Z and swap its context is the context is changed', ->
    Z.fn 'param', (context) -> context

    Z().param.call('yolo').should.eql 'yolo'
    Z.param.call('yolo').should.eql 'yolo'

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

