Z = require '../src/zimple'

describe 'zimple #fn chaining', ->
  it 'should allow logical linking of plugins', ->
    Z.fn 'reduce', (arr, fn) -> arr.reduce fn
    Z.fn 'summarize', (a, b) -> a + b
    Z.fn 'sum',    (arr) -> Z.reduce arr, Z.summarize

    Z([2,5,6]).sum().should.eql 13
    Z.sum([2,5,6]).should.eql 13

  it 'should allow logical linking of plugins (using reference)', ->
    Z.fn 'reduce', (arr, fn) -> arr.reduce fn
    Z.fn 'summarize', (a, b) -> a + b
    Z.fn 'sum', (arr) -> Z.reduce arr, Z.summarize

    sum = Z([2,5,6]).sum
    sum().should.eql 13

    sum = Z.sum
    sum([2,5,6]).should.eql 13

  it 'should allow logical linking of plugins (with this)', ->
    Z.fn 'reduce', (arr, fn) -> arr.reduce fn
    Z.fn 'summarize', (a, b) -> a + b
    Z.fn 'sum',    (arr) -> @reduce arr, @summarize

    Z([2,5,6]).sum().should.eql 13
    Z.sum([2,5,6]).should.eql 13

  it 'should allow logical linking of plugins (using reference)', ->
    Z.fn 'reduce', (arr, fn) -> arr.reduce fn
    Z.fn 'summarize', (a, b) -> a + b
    Z.fn 'sum', (arr) -> @reduce arr, @summarize

    sum = Z([2,5,6]).sum
    sum().should.eql 13

    sum = Z.sum
    sum([2,5,6]).should.eql 13

  it 'should not mutate original context when chaining', ->
    org = [ 1,2,3 ]
    Z.fn 'map', (arr, fn) -> arr.map fn
    Z.fn 'double', (a) -> a * 2
    Z.fn 'doubleList', (arr) -> this.map arr, this.double

    Z(org).doubleList().should.eql [ 2, 4, 6 ]
    org.should.eql [ 1, 2, 3 ]
