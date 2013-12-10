global.Z = require '../../src/zimple'
require './curry'

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

  it 'should mark parameter count as the optional parameter (wrapped)', ->
    def = (a, b, c, d, e, f) ->
      arguments.length.should.eql 2
      a + b

    par = Z(def).curry 2
    par('xxx').should.be.type 'function'
    par('xxx', 'asd').should.eql 'xxxasd'

  it 'should mark parameter count as the optional parameter (partial)', ->
    def = (a, b, c, d, e, f) ->
      arguments.length.should.eql 2
      a + b

    par = Z.curry def, 2
    par('xxx').should.be.type 'function'
    par('xxx', 'asd').should.eql 'xxxasd'

  it 'should be able to set parameter count as 0', ->
    def = (a, b, c) -> arguments.length.should.eql 0

    par = Z.curry def, 0
    par()

  it 'should pass extra params to function if the max param count is given', ->
    def = (a, b, c) -> c.should.eql 'paul'

    par = Z.curry def, 0
    par 'hello', 'kitty', 'paul'

  it 'should fulfil partial functions', ->
    calc   = (x, y) -> x + y
    addTwo = Z.curry(calc) 2
    addTwo(4).should.eql 6

    addTwo = Z(calc).curry() 2
    addTwo(4).should.eql 6

  it 'should be reusable (one link)', ->
    calc   = (x, y, z) -> x + y + z
    addTwo = Z.curry(calc) 2
    addTwo(4, 4).should.eql 10
    addTwo(10, 6).should.eql 18

  it 'should be reusable (multiple links)', ->
    calc   = (x, y, z) -> x + y + z
    addTwo = Z.curry(calc) 2

    addFour = addTwo(2)
    addFour(4).should.eql 8
    addFour(24).should.eql 28

  it 'should return a new curried object unless all arguments are fulfilled (partial)', ->
    calc = (x, y, z) -> x + y + z
    Z.curry(calc)()(1,2,3).should.eql 6
    Z.curry(calc)()(1)(2)(3).should.eql 6
    Z.curry(calc)()(1, 2)(3).should.eql 6
    Z.curry(calc)()(1)(2, 3).should.eql 6

  it 'should return a new curried object unless all arguments are fulfilled (wrapped)', ->
    calc = (x, y, z) -> x + y + z
    Z(calc).curry()(1,2,3).should.eql 6
    Z(calc).curry()(1)(2)(3).should.eql 6
    Z(calc).curry()(1,2)(3).should.eql 6
    Z(calc).curry()(1)(2, 3).should.eql 6

  it 'should work with Z plugins', ->
    Z.fn 'sum',    (x, y) -> x * y
    Z.fn 'double', (arr)  -> arr.map @curry(@sum) 2

    Z([2, 4]).double().should.eql [4, 8]
    Z.double([2, 4]).should.eql [4, 8]

  it 'should work with Z plugins in chain', ->
    Z.fn 'sum',    (x, y) -> x * y
    Z.fn 'double', (arr)  -> arr.map @curry(@sum) 2

    Z([2, 4]).chain().double().value().should.eql [4, 8]
    Z.chain([2, 4]).double().value().should.eql [4, 8]

