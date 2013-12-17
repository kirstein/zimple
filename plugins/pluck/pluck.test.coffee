global.Z = require '../../src/zimple'
require './pluck'

plugins = Z::__plugins

describe 'pluck plugin', ->
  afterEach  -> Z::__plugins = {}
  beforeEach -> Z::__plugins = plugins

  it 'should exist', ->
    Z.pluck.should.be.ok
    Z().pluck.should.be.ok

  it 'should return all chars at given place', ->
    Z.pluck([ 'tere', 'asdd' ], 0).should.eql [ 't', 'a' ]
    Z(['tere', 'asdd']).pluck(0).should.eql [ 't', 'a' ]

  it 'should return undefined is place is larger than the length of the data', ->
    Z.pluck([ 'tere', 'asdd' ], 100).should.eql [ undefined, undefined ]
    Z(['tere', 'asdd']).pluck(100).should.eql [ undefined, undefined ]

  it 'should return the object with the given key', ->
    Z.pluck([ kala : 123, peeter : 123 ], 'kala').should.eql [ 123 ]
    Z([ kala : 123, peeter : 123 ]).pluck('kala').should.eql [ 123 ]

  it 'should return an array with the same count of items when the key was null', ->
    Z.pluck([2,5,7,1,9], null).length.should.eql 5
    Z.pluck([undefined, undefined, undefined, undefined, undefined], null).length.should.eql 5

  it 'should return an empty array when the target was null or undefined', ->
    Z.pluck(null, null).should.eql []
    Z.pluck(null, 0).should.eql []
    Z.pluck(undefined, undefined).should.eql []
    Z.pluck(undefined, 0).should.eql []
