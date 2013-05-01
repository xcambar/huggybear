chai      = require 'chai'
sinonChai = require 'sinon-chai'
sinon     = require 'sinon'
mockery   = require 'mockery'

chai.use sinonChai
chai.should()

huggyBear = null

before -> mockery.enable(warnOnUnregistered: false)
after -> mockery.disable()

before ->
  mockery.registerMock 'mockObject', {}
  mockery.registerMock 'mockFn', ->

beforeEach ->
  delete require.cache[require.resolve '../index']
  huggyBear = require '../index'

buildSpyMock = (fn)->
  spy = sinon.spy fn
  name = Math.random().toString()
  mockery.registerMock name, spy
  [name, spy]


describe 'Calling for modules', ->
  
  it 'should require to use existing modules', ->
    huggyBear.provide.bind(undefined, {}, 'nonExistingModule').should.throw
  
  it 'should require to use modules returning a function', ->
    huggyBear.provide.bind(undefined, {}, 'mockObject').should.throw
    huggyBear.provide.bind(undefined, {}, 'mockFn').should.not.throw


describe 'Using a function module', ->

  it 'should call the function returned with the module', ->
    [name, spy] = buildSpyMock()
    huggyBear.provide {}, name
    spy.should.have.been.called
  
  it 'should call the function with the left-most arguments', ->
    [name, spy] = buildSpyMock()
    arg1 = 'foo'
    arg2 = ->
    huggyBear.provide {}, name, arg1, arg2
    spy.should.have.been.calledWith arg1, arg2
  
  it 'should return the evaluated function module', ->
    obj = {}
    [name, spy] = buildSpyMock -> obj
    arg1 = 'foo'
    arg2 = ->
    ret = huggyBear.provide {}, name, arg1, arg2
    ret.should.equal obj


describe 'Retrieving dependencies', ->

  it 'should always return the same instance of the evaluated module for a single source', ->
    obj = {}
    src = {}
    [name, spy] = buildSpyMock -> obj
    ret1 = huggyBear.provide src, name
    ret2 = huggyBear.provide src, name
    spy.should.have.been.calledOnce
    ret1.should.equal ret2

  it 'should reevaluate the function module for a new source', ->
    [name, spy] = buildSpyMock -> {}
    ret1 = huggyBear.provide {}, name
    ret2 = huggyBear.provide {}, name
    spy.should.have.been.calledTwice
    ret1.should.not.equal ret2


