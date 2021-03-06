global.Z = require '../../src/zimple'
require './once'

assert = require 'assert'
sinon  = require 'sinon'

describe 'once plugin', ->
  it 'should be defined', ->
    Z.once.should.be.ok

  it 'should throw if no function is defined', ->
    (-> Z.once []).should.throw 'Z.once: No function defined'
    (-> Z().once()).should.throw 'Z.once: No function defined'

  it 'should not be chainable', ->
    assert Z.chain().once   == undefined
    assert Z().chain().once == undefined

  it 'should return a function', ->
    fn = Z.once ->
    fn.should.be.type 'function'

    fn = Z(->).once()
    fn.should.be.type 'function'

  it 'should pass the context', ->
    fn = Z.once (-> @), asd : 123
    fn().should.eql asd : 123

    fn = Z(-> @).once asd : 123
    fn().should.eql asd : 123

  it 'should pass the params to original function', ->
    spy = sinon.spy()
    fn  = Z.once(spy) 'arg1', 'arg2', 'arg3'
    assert spy.calledWith 'arg1', 'arg2', 'arg3'

    spy = sinon.spy()
    fn  = Z(spy).once() 'arg1', 'arg2', 'arg3'
    assert spy.calledWith 'arg1', 'arg2', 'arg3'

  it 'should call the function only once', ->
    spy = sinon.spy()
    fn  = Z.once(spy)
    fn()
    fn()
    spy.callCount.should.eql 1

    spy = sinon.spy()
    fn  = Z(spy).once()
    fn()
    fn()
    spy.callCount.should.eql 1

  it 'should replay the previous response if called more than once', ->
    count = 0
    fn  = Z.once -> ++count
    fn().should.eql 1
    fn().should.eql 1

    count = 0
    fn  = Z(-> ++count).once()
    fn().should.eql 1
    fn().should.eql 1

  it 'should be used in other plugins', ->
    spy = sinon.spy()
    Z.fn 'once_inctimes', (count, spy) ->
      once = this.once(spy)
      once i for i in [0..count]
    Z.once_inctimes(10, spy)
    spy.callCount.should.eql 1

  it 'should be used in other plugins (wrapper)', ->
    spy = sinon.spy()
    Z.fn 'once_inctimes', (count, spy) ->
      once = this.once(spy)
      once i for i in [0..count]
    Z(10).once_inctimes(spy)
    spy.callCount.should.eql 1
