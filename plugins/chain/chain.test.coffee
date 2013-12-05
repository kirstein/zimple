Z      = require '../../src/zimple'
sinon  = require 'sinon'
assert = require 'assert'

describe 'chain plugin', ->

  it 'should be defined', ->
    Z.chain.should.be.ok

  it 'should expose result after the chain has started', ->
    assert Z.result == undefined
    Z.chain('one').result.should.be.ok
    Z('one').chain().result.should.be.ok

  it 'should expose result after the chain has started', ->
    assert Z.result == undefined
    Z.chain('one').result.should.be.ok
    Z('one').chain().result.should.be.ok

  it 'should not link function names starting with _', ->
    Z::_testFn = ->
    assert Z('one').chain()._testFn == undefined
    assert Z.chain('one')._testFn == undefined
    Z::_testFn = undefined

  it 'should pass arguments', ->
    Z.fn 'argguard', (context, arg) ->
      throw new Error "Invalid argument passed" if arg != 'wat'

    Z().chain().argguard('wat').result()
    Z.chain().argguard('wat').result()

  it 'should pass the correct context', ->
    Z.fn 'call', (context, arg) ->
      throw new Error "Invalid argument passed: #{arg}" if arg
      context()

    spy = sinon.spy()
    Z(spy).chain().call().result()
    spy.called.should.be.ok

    spy = sinon.spy()
    Z.chain(spy).call().result()
    spy.called.should.be.ok

  describe 'mutations', ->
    beforeEach ->
      Z.fn 'removeFirst', (arr) -> arr.slice 1
      Z.fn 'sum', (arr) -> arr.reduce (old, val) -> old+val
      Z.fn 'double', (val) -> val * 2

    it 'should receive the same result each time (PARTIAL)', ->
      chain = Z.chain([2,5,6,82]).removeFirst().sum().double()

      chain.result().should.eql 186
      chain.result().should.eql 186
      chain.result().should.eql 186

    it 'should receive the same result each time (FULL)', ->
      chain = Z([2,5,6,82]).chain().removeFirst().sum().double()

      chain.result().should.eql 186
      chain.result().should.eql 186
      chain.result().should.eql 186

  describe 'linking', ->
    beforeEach ->
      Z.fn 'uppercase', (context) -> context.toUpperCase()
      Z.fn 'reverse',   (context) -> context.split('').reverse().join('')

    it 'should receive the value after chaining', ->
      Z('one').chain().reverse().result().should.eql 'eno'
      Z.chain('one').reverse().result().should.eql 'eno'

    it 'should receive the value after chaining (MULTIPLE LINKS)', ->
      Z('one').chain().reverse().uppercase().result().should.eql 'ENO'
      Z.chain('one').reverse().uppercase().result().should.eql 'ENO'

    it 'should not call the function unless result is called', ->
      spy = sinon.spy()
      Z.fn 'test', spy
      Z('one').chain().test()
      Z.chain('one').test()

      spy.called.should.be.not.ok

    it 'should not call the function unless result is called even if its chained', ->
      spy  = sinon.spy()
      spy2 = sinon.spy()

      Z.fn 'test', spy
      Z.fn 'test2', spy2
      Z('one').chain().test().test2()
      Z.chain('one').test().test2()

      spy.called.should.be.not.ok
      spy2.called.should.be.not.ok
