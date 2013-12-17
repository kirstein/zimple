global.Z = require '../../src/zimple'
require './filter'

sinon  = require 'sinon'
assert = require 'assert'

plugins = Z::__plugins

describe 'filter plugin', ->
  afterEach  -> Z::__plugins = {}
  beforeEach -> Z::__plugins = plugins

  it 'should exist', -> Z.filter.should.be.ok
  it 'should call the predicate on each array member', ->
    spy = sinon.spy()
    Z([1,2,5]).filter(spy)
    spy.callCount.should.eql 3

  it 'should remove items that do not pass the predicate', ->
    filterFn = (item) -> item is 2
    Z([1,2,5]).filter(filterFn).should.eql [2]

  it 'should pass the correct thisarg', ->
    thisArg  = {}
    filterFn = -> assert @ is thisArg
    Z([1,2,5]).filter filterFn, thisArg




