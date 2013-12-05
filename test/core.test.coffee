Z = require '../src/zimple'

describe 'zimple core', ->
  it 'should exist', ->
    Z.should.be.ok

  it 'should return new Z instance if called without new keyword', ->
    new Z().should.eql Z()

  describe 'plugins', ->
    describe '#fn', ->
      it 'should expose plugin', ->
        Z.fn 'count', ->
        Z.count.should.be.ok
        Z().count.should.be.ok

      it 'should throw if the given plugin has no function', ->
        (->
          Z.fn 'sum'
        ).should.throw 'No function defined for plugin \'sum\''

      it 'should throw if the given plugin has no name', ->
        (->
          Z.fn()
        ).should.throw 'No plugin name defined'

      it 'should handle the same way with initiation and without', ->
        Z.fn 'sum', (arr) ->
          arr.reduce (old, val) -> old + val

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

      it 'should create chainable plugins (context change)', ->
        Z.fn 'uppercase', (context) ->
          context.toUpperCase()

        Z.fn 'reverse', (context) ->
          context.split('').reverse().join('')

        Z.fn 'mutate', (context) ->
          @uppercase.call @reverse.call context

        Z('hello').mutate().should.eql 'OLLEH'
        Z.mutate('hello').should.eql 'OLLEH'


      it 'should create chainable plugins (argument)', ->
        Z.fn 'uppercase', (context, text) ->
          text.toUpperCase()

        Z.fn 'reverse', (context, text) ->
          text.split('').reverse().join('')

        Z.fn 'mutate', (context) ->
          @uppercase @reverse context

        Z('hello').mutate().should.eql 'OLLEH'
        Z.mutate('hello').should.eql 'OLLEH'

      it 'should chain if context has changed', ->
        Z.fn 'beep', ->
          'beep'

        Z.fn 'triggerbeep', ->
          @beep()

        Z.fn 'trigger', ->
          @triggerbeep.call()

        Z().trigger().should.eql 'beep'
        Z.trigger().should.eql 'beep'


