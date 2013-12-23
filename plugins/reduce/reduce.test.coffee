sinon  = require 'sinon'
assert = require 'assert'

require './reduce'

describe 'reduce plugin', ->
  it 'should exist', -> Z.reduce.should.be.ok

  it 'should call the given function', ->
    Z.reduce [ 1,2 ], spy = sinon.spy()
    spy.called.should.be.ok

  it 'should pass the first value if no initial value is given', ->
    spy = sinon.spy()
    Z.reduce [ 21, 2 ], spy
    spy.firstCall.args[0].should.eql 21

  it 'should pass the initial value if given', ->
    spy = sinon.spy()
    Z.reduce [ 1, 2 ], spy, 'hello'
    spy.firstCall.args[0].should.eql 'hello'

  it 'should return the right sum if initial value is given', ->
    Z.reduce([ 1,2 ], ((old, val) -> old + val), 0).should.eql 3

  it 'should return the right sum if initial value is not given', ->
    Z.reduce([ 1,2 ], ((old, val) -> old + val)).should.eql 3
