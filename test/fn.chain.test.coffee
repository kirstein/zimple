Z = require '../src/zimple'

plugins = Z::__plugins

describe 'zimple #fn chaining', ->
  afterEach -> Z::__plugins = plugins

  it 'should allow logical linking of plugins', ->
    Z.fn 'fn_reduce', (arr, fn) -> arr.reduce fn
    Z.fn 'fn_summarize', (a, b) -> a + b
    Z.fn 'fn_sum',    (arr) -> Z.fn_reduce arr, Z.fn_summarize

    Z([2,5,6]).fn_sum().should.eql 13
    Z.fn_sum([2,5,6]).should.eql 13

  it 'should allow logical linking of plugins (using reference)', ->
    Z.fn 'fn_reduce', (arr, fn) -> arr.reduce fn
    Z.fn 'fn_summarize', (a, b) -> a + b
    Z.fn 'fn_sum', (arr) -> Z.fn_reduce arr, Z.fn_summarize

    fn_sum = Z([2,5,6]).fn_sum
    fn_sum().should.eql 13

    fn_sum = Z.fn_sum
    fn_sum([2,5,6]).should.eql 13

  it 'should allow logical linking of plugins (with this)', ->
    Z.fn 'fn_reduce', (arr, fn) -> arr.reduce fn
    Z.fn 'fn_summarize', (a, b) -> a + b
    Z.fn 'fn_sum',    (arr) -> @fn_reduce arr, @fn_summarize

    Z([2,5,6]).fn_sum().should.eql 13
    Z.fn_sum([2,5,6]).should.eql 13

  it 'should allow logical linking of plugins (using reference)', ->
    Z.fn 'fn_reduce', (arr, fn) -> arr.reduce fn
    Z.fn 'fn_summarize', (a, b) -> a + b
    Z.fn 'fn_sum', (arr) -> @fn_reduce arr, @fn_summarize

    fn_sum = Z([2,5,6]).fn_sum
    fn_sum().should.eql 13

    fn_sum = Z.fn_sum
    fn_sum([2,5,6]).should.eql 13

  it 'should not mutate original context when chaining', ->
    org = [ 1,2,3 ]
    Z.fn 'map', (arr, fn) -> arr.map fn
    Z.fn 'double', (a) -> a * 2
    Z.fn 'doubleList', (arr) -> this.map arr, this.double

    Z(org).doubleList().should.eql [ 2, 4, 6 ]
    org.should.eql [ 1, 2, 3 ]
