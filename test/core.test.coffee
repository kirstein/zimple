Z      = require '../src/zimple'
assert = require 'assert'

describe 'zimple core', ->
  it 'should exist', ->
    Z.should.be.ok

  it 'should return new Z instance if called without new keyword', ->
    # For mock sake lets remove all plugins
    Z::__plugins = {}
    new Z().should.eql Z()

  it 'should not create a new instance of Z on each call', ->
    Z.fn 'test', -> @
    z = new Z()
    assert z.test() == z

    z = Z()
    assert z.test().test() == z
