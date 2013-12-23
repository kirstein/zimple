Z      = require '../src/zimple'
assert = require 'assert'

describe 'zimple core', ->
  it 'should exist', ->
    Z.should.be.ok

  it 'should return new Z instance if called without new keyword', ->
    Z::__plugins = {}
    new Z().should.eql Z()
