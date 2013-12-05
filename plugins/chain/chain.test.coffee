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

  describe 'linking (sync)', ->
    beforeEach ->
      Z.fn 'uppercase', (context) -> context.toUpperCase()
      Z.fn 'reverse',   (context) -> context.split('').reverse().join('')

    it 'should receive the value after chaining', ->
      Z('one').chain(async : false).reverse().result().should.eql 'eno'
      Z.chain('one', async : false).reverse().result().should.eql 'eno'

    it 'should receive the value after chaining (MULTIPLE LINKS)', ->
      Z('one').chain(async : false).reverse().uppercase().result().should.eql 'ENO'
      Z.chain('one', async : false).reverse().uppercase().result().should.eql 'ENO'

    it 'should call the function straight away', ->
      spy = sinon.spy()
      Z.fn 'test', spy
      Z('one').chain( async : false ).test()
      spy.called.should.be.ok

      spy = sinon.spy()
      Z.fn 'test', spy
      Z.chain('one', async : false).test( )
      spy.called.should.be.ok

  describe 'linking (async)', ->
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









