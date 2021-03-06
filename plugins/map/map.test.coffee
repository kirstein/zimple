global.Z = require '../../src/zimple'

sinon  = require 'sinon'
assert = require 'assert'

require './map'

describe 'map plugin', ->
  it 'should exist', ->
    Z.map.should.be.ok

  it 'should trigger defined function N times where N is array length', ->
    spy = sinon.spy()
    Z([2,5,6,1,2]).map spy
    spy.callCount.should.eql 5

  it 'should return an array', ->
    res = Z([1,2]).map (x) -> x
    Array.isArray(res).should.be.ok

  it 'should create a new array', ->
    arr = [ 1, 2 ]
    res = Z(arr).map (x) -> x
    assert res != arr

  it 'should replace each value of an array with FN return value', ->
    hello = -> 'hello'
    arr   = [1,2,5,6]
    res   = Z(arr).map hello
    res.length.should.eql arr.length
    res.should.eql [ 'hello', 'hello', 'hello', 'hello' ]

  it 'should pass the array object to fn', ->
    double = (x) -> x*2
    (Z([1,2,5]).map double).should.eql [2,4,10]
    (Z.map [1,2,5], double).should.eql [2,4,10]

  it 'should work with `thisarg`', ->
    context = {}
    fn      = -> assert @ == context
    Z([1,2,5]).map fn, context
    Z.map [1,2,5], fn, context

  it 'should work in plugins', ->
    double = (val) -> val*2
    Z.fn 'map_test', (arr) -> this.map arr, double
    Z([1,2,5,6]).map_test().should.eql [2,4,10,12]
    Z.map_test([1,2,5,6]).should.eql [2,4,10,12]
