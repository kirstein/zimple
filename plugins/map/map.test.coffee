global.Z = require '../../src/zimple'
require './map'

sinon  = require 'sinon'
assert = require 'assert'

describe 'map plugin', ->
  it 'should exist', ->
    Z.map.should.be.ok

  it 'should throw when no array is defined', ->
    (-> Z.map()).should.throw 'Z.map: No array defined'
    (-> Z().map()).should.throw 'Z.map: No array defined'

  it 'should throw when no function is defined', ->
    (-> Z.map([])).should.throw 'Z.map: No function defined'
    (-> Z([]).map()).should.throw 'Z.map: No function defined'

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

  it 'should pass wrapper as default this', ->
    Z([1,2,5]).map -> assert @ instanceof Z
    Z.map [1,2,5], -> assert @ instanceof Z

  it 'should work in plugins', ->
    double = (val) -> val*2
    Z.fn 'test', (arr) -> this.map arr, double
    Z([1,2,5,6]).test().should.eql [2,4,10,12]
    Z.test([1,2,5,6]).should.eql [2,4,10,12]
