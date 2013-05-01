require 'es6-shim'

huggyMap = new Map()

slice = Array.prototype.slice



module.exports =
  # @param {mixed} ref of the dependent
  # @param {String} name of the module to bind
  provide: ()->
    args = slice.call arguments
    ref = args.shift()
    name = args.shift()

    if huggyMap.has ref
      refDeps = huggyMap.get ref 
    else
      refDeps = {}
      huggyMap.set ref, refDeps
    if !refDeps[name]
      refDeps[name] = require(name).apply undefined, args
    refDeps[name]

