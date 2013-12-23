global.Z = require '../../src/zimple'
require './invoke'

sinon  = require 'sinon'
assert = require 'assert'

describe 'invoke plugin', ->

  it 'should exist', ->
    Z.invoke.should.be.ok
    Z().invoke.should.be.ok

  it 'should trigger given fn on each array member (wrapped)', ->
    obj = 'test' : spy = sinon.spy()
    Z([obj]).invoke('test')
    spy.calledOnce.should.be.ok

  it 'should trigger given fn on each array member', ->
    obj = 'test' : spy = sinon.spy()
    Z.invoke([obj], 'test')
    spy.calledOnce.should.be.ok

  it 'should return an array with return values', ->
    obj = 'hello' : -> 'handsome'
    Z([obj]).invoke('hello').should.eql [ 'handsome' ]
    Z.invoke([obj], 'hello').should.eql [ 'handsome' ]

  it 'should pass additional arguments', ->
    obj = 'hello' : (one, two) ->
      one.should.eql 1
      two.should.eql 2
    Z([obj]).invoke('hello', 1, 2)
    Z.invoke [obj], 'hello', 1, 2

  it 'should pass null or undefined', ->
    obj = 'hello' : (one, two) ->
      assert typeof one is 'undefined'
      assert two is null
    Z([obj]).invoke('hello', undefined, null)
    Z.invoke [obj], 'hello', undefined, null

  it 'should work with numbers', ->
    Z([1,2,5,9]).invoke('toString')
    Z.invoke([1,2,5,9], 'toString')

  it 'should work with strings', ->
    Z(['one', 'two']).invoke('split')
    Z.invoke(['one', 'two'], 'split')
