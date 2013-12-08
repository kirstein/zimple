Z      = require '../../src/zimple'
assert = require 'assert'

describe 'curry plugin', ->

  it 'should be defined', ->
    Z.curry.should.be.ok
    Z().curry.should.be.ok

  it 'should not be chainable', ->
    assert Z.chain().curry   == undefined
    assert Z().chain().curry == undefined

  it 'should throw when no function is passed', ->
    (-> Z({}).curry()).should.throw 'Z.curry: No function defined'
    (-> Z.curry({})).should.throw 'Z.curry: No function defined'

  it 'should return a partial function', ->
    Z.curry(->).should.be.ok
    Z(->).curry().should.be.ok

  it 'should fulfil partial functions', ->
    calc   = (x, y) -> x + y
    addTwo = Z.curry(calc, 2)
    addTwo(4).should.eql 6

    addTwo = Z(calc).curry(2)
    addTwo(4).should.eql 6

  it 'should return a new curried object unless all arguments are fulfilled (partial)', ->
    calc = (x, y, z) -> x + y + z
    Z.curry(calc)()(1,2,3).should.eql 6
    Z.curry(calc)()(1)(2)(3).should.eql 6
    Z.curry(calc)(1)(2)(3).should.eql 6
    Z.curry(calc)(1, 2)(3).should.eql 6
    Z.curry(calc)(1)(2, 3).should.eql 6

  it 'should return a new curried object unless all arguments are fulfilled (wrapped)', ->
    calc = (x, y, z) -> x + y + z
    Z(calc).curry()(1,2,3).should.eql 6
    Z(calc).curry()(1)(2)(3).should.eql 6
    Z(calc).curry(1)(2)(3).should.eql 6
    Z(calc).curry(1, 2)(3).should.eql 6
    Z(calc).curry(1)(2, 3).should.eql 6



