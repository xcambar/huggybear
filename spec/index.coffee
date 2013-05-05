chai      = require 'chai'
sinonChai = require 'sinon-chai'
sinon     = require 'sinon'
mockery   = require 'mockery'

chai.use sinonChai
chai.should()

huggyBear = require '../index'

before -> mockery.enable(warnOnUnregistered: false)
after -> mockery.disable()

before ->
  mockery.registerMock 'mockObject', {}
  mockery.registerMock 'mockFn', ->

buildSpyMock = (fn)->
  spy = sinon.spy fn
  name = Math.random().toString()
  mockery.registerMock name, spy
  [name, spy]


describe 'Calling for modules', ->
  
  it 'should require to use existing modules', ->
    huggyBear().provide.bind(undefined, {}, 'nonExistingModule').should.throw()
  
  it 'should require to use modules returning a function', ->
    huggyBear().provide.bind(undefined, {}, 'mockObject').should.throw()
    huggyBear().provide.bind(undefined, {}, 'mockFn').should.not.throw()


describe 'Defining a mixin', ->

  it 'should call the function returned with the module', ->
    [name, spy] = buildSpyMock()
    huggyBear().provide {}, name
    spy.should.have.been.called
  
  it 'should call the function with the left-most arguments', ->
    [name, spy] = buildSpyMock()
    arg1 = 'foo'
    arg2 = ->
    huggyBear().provide {}, name, arg1, arg2
    spy.should.have.been.calledWith arg1, arg2
  
  it 'should return the evaluated function module', ->
    obj = {}
    [name, spy] = buildSpyMock -> obj
    ret = huggyBear().provide {}, name
    ret.should.equal obj

  it 'should not be allowed to replace an existing mixin', ->
    src = {}
    [name, spy] = buildSpyMock()
    huggy = huggyBear()
    huggy.provide src, name
    huggy.provide.bind(undefined, src, name).should.throw "The mixin #{name} has already been defined."


describe 'Retrieving dependencies', ->

  it 'should always return the same instance of the mixin for a single source', ->
    obj = {}
    src = {}
    [name, spy] = buildSpyMock -> obj
    huggy = huggyBear()
    ret1 = huggy.provide src, name
    ret2 = huggy.claim src, name
    spy.should.have.been.calledOnce
    ret1.should.equal ret2

  it 'should reevaluate the mixin for a new source', ->
    [name, spy] = buildSpyMock -> {}
    huggy = huggyBear()
    ret1 = huggy.provide {}, name
    ret2 = huggy.provide {}, name
    spy.should.have.been.calledTwice
    ret1.should.not.equal ret2

  it 'should throw if a mixin is required for an unknown object', ->
    huggyBear().claim.bind(undefined, {}, 'anything').should.throw 'No mixin defined'

  it 'should throw if a mixin is unknown to an object', ->
    obj = {}
    [name, spy] = buildSpyMock()
    huggy = huggyBear()
    huggy.provide obj, name
    huggy.claim.bind(undefined, obj, 'anything').should.throw 'No mixin anything defined'

  it 'should be able to retrieve a defined mixin', ->
    ret = gonnaBe: 'awesome'
    obj = {}
    [name, spy] = buildSpyMock -> ret
    huggy = huggyBear()
    def = huggy.provide obj, name
    def2 = huggy.claim obj, name
    def.should.equal def2

describe 'Multiple containers', ->
  it 'should be isolated', ->
    huggy1 = huggyBear()
    huggy2 = huggyBear()
    [name, spy] = buildSpyMock()
    obj = {}
    huggy1.provide obj, name
    huggy2.claim.bind(undefined, obj, name).should.throw

