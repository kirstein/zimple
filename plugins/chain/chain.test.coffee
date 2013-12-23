global.Z = require '../../src/zimple'

sinon  = require 'sinon'
assert = require 'assert'

require './chain'

describe 'chain plugin', ->
  it 'should be defined', ->
    Z.chain.should.be.ok

  describe 'chain linking', ->

    it 'should not chain with itself', ->
      assert Z('one').chain().chain == undefined

    it 'should not link functions that have set chain false property', ->
      Z.fn 'chain_testFn', (->), chain : false
      assert Z('one').chain().chain_testFn == undefined
      assert Z.chain('one').chain_testFn == undefined

    it 'should only chain plugins', ->
      Z::chain_test_something = 1
      assert Z('one').chain().chain_test_something == undefined
      assert Z.chain('one').chain_test_something == undefined

  it 'should expose value after the chain has started', ->
    assert Z.value == undefined
    Z.chain('one').value.should.be.ok
    Z('one').chain().value.should.be.ok

  it 'should pass arguments', ->
    Z.fn 'chain_args_test', (context, arg) -> arg.should.eql 'wat'

    Z().chain().chain_args_test('wat').value()
    Z.chain().chain_args_test('wat').value()

  it 'should pass the correct context', ->
    Z.fn 'chain_call_test', (context, arg) ->
      assert arg == undefined
      context()

    spy = sinon.spy()
    Z(spy).chain().chain_call_test().value()
    spy.called.should.be.ok

    spy = sinon.spy()
    Z.chain(spy).chain_call_test().value()
    spy.called.should.be.ok

  describe 'mutations', ->
    beforeEach ->
      Z.fn 'chain_remove_first', (arr) -> arr.slice 1
      Z.fn 'chain_sum', (arr) -> arr.reduce (old, val) -> old+val
      Z.fn 'chain_double', (val) -> val * 2

    it 'should receive the same value each time (PARTIAL)', ->
      chain = Z.chain([2,5,6,82]).chain_remove_first().chain_sum().chain_double()

      chain.value().should.eql 186
      chain.value().should.eql 186
      chain.value().should.eql 186

    it 'should receive the same value each time (FULL)', ->
      chain = Z([2,5,6,82]).chain().chain_remove_first().chain_sum().chain_double()

      chain.value().should.eql 186
      chain.value().should.eql 186
      chain.value().should.eql 186

  describe 'linking', ->
    beforeEach ->
      Z.fn 'chain_uppercase', (context) -> context.toUpperCase()
      Z.fn 'chain_reverse',   (context) -> context.split('').reverse().join('')

    it 'should receive the value after chaining', ->
      Z('one').chain().chain_reverse().value().should.eql 'eno'
      Z.chain('one').chain_reverse().value().should.eql 'eno'

    it 'should work when the original context has been changed', ->
      context = [ 1,2,3,4 ]
      Z.fn 'chain_double', (val) -> val * 2
      Z.fn 'chain_sum', (arr)    -> arr.reduce (a, v) -> a + v
      chain = Z(context).chain().chain_sum().chain_double()
      context.push 20
      chain.value().should.eql 60

    it 'should work when the original context has changed (partial)', ->
      context = [ 1,2,3,4 ]
      Z.fn 'chain_double', (val) -> val * 2
      Z.fn 'chain_sum', (arr)    -> arr.reduce (a, v) -> a + v
      chain = Z.chain(context).chain_sum().chain_double()
      context.push 20
      chain.value().should.eql 60

    it 'should receive the value after chaining (MULTIPLE LINKS)', ->
      Z('one').chain().chain_reverse().chain_uppercase().value().should.eql 'ENO'
      Z.chain('one').chain_reverse().chain_uppercase().value().should.eql 'ENO'

    it 'should not call the function unless value is called', ->
      spy = sinon.spy()
      Z.fn 'chain_call_test', spy
      Z('one').chain().chain_call_test()
      Z.chain('one').chain_call_test()

      spy.called.should.be.not.ok

    it 'should not call the function unless value is called even if its chained', ->
      spy  = sinon.spy()
      spy2 = sinon.spy()

      Z.fn 'chain_test_1', spy
      Z.fn 'chain_test_2', spy2
      Z('one').chain().chain_test_1().chain_test_2()
      Z.chain('one').chain_test_1().chain_test_2()

      spy.called.should.be.not.ok
      spy2.called.should.be.not.ok

    it 'should work with generic Z chains', ->
      Z.fn 'chain_reduce', (arr, fn) -> arr.reduce fn
      Z.fn 'chain_summarize', (a, b) -> a + b
      Z.fn 'chain_sum', (arr) -> Z.chain_reduce arr, Z.chain_summarize

      Z([2,5,6]).chain().chain_sum().value().should.eql 13
      Z.chain([2,5,6]).chain_sum().value().should.eql 13

    it 'should work with generic Z chains (this usage)', ->
      Z.fn 'chain_reduce', (arr, fn) -> arr.reduce fn
      Z.fn 'chain_summarize', (a, b) -> a + b
      Z.fn 'chain_sum', (arr) -> @chain_reduce arr, @chain_summarize

      Z([2,5,6]).chain().chain_sum().value().should.eql 13
      Z.chain([2,5,6]).chain_sum().value().should.eql 13
