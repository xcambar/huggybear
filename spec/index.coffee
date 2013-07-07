chai      = require 'chai'
sinonChai = require 'sinon-chai'
sinon     = require 'sinon'
# mockery   = require 'mockery'

chai.use sinonChai
chai.should()

huggyBear = require '../index'


describe 'providing a dependency', ->
  it 'should be possible to declare a new dependency to an object', ->
    huggyBear().provide.bind(undefined, {}, 'depname', {}).should.not.throw()
  it 'should not be possible to declare an existing dependency', ->
    obj = {}
    dep = {}
    hg = huggyBear();
    hg.provide(obj, 'depName', dep)
    hg.provide.bind(undefined, obj, 'depName', dep).should.throw()

describe 'dependency isolation', ->
  it 'should not be possible to retrieve a dependency of another object', ->
    obj = {}
    hg = huggyBear();
    hg.provide(obj, 'depName', {})
    hg.claim.bind(undefined, {}, 'depName').should.throw()

describe 'retrieving dependencies', ->
  it 'should be possible to retrieve a stored dependency', ->
    obj = {}
    dep = {}
    hg = huggyBear();
    hg.provide(obj, 'depName', dep)
    hg.claim(obj, 'depName').should.be.equal dep
  it 'should throw when a dependency has not been defined', ->
    huggyBear().claim.bind(undefined, {}, 'depName').should.throw()

describe 'generic dependencies', ->
  it 'should be possible to register generic dependencies', ->
    huggyBear().generic('depName', ->)
  it 'should throw if the generic dep has no constructor function', ->
    huggyBear().generic.bind(undefined, 'depName', {}).should.throw()
  describe 'using generic dependencies', ->
    it 'should be available to all the objects that want to register', ->
      obj = {}
      ret = {}
      hg = huggyBear()
      hg.generic('generic', -> ret)
      hg.claim(obj, 'generic').should.be.equal ret

