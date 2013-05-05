"use strict";
require('es6-shim');

var slice = Array.prototype.slice;

function factory () {
  var huggyMap = new Map();


  var huggy = {
    provide: function () {
      var args = slice.call(arguments);
      var ref = args.shift();
      var name = args.shift();
      var refDeps;

      if (huggyMap.has(ref)) {
        refDeps = huggyMap.get(ref);
      } else {
        refDeps = {};
        huggyMap.set(ref, refDeps);
      }
      if (refDeps.hasOwnProperty(name)) {
        throw new ReferenceError('The mixin ' + name + ' has already been defined.');
      }
      refDeps[name] = require(name).apply(undefined, args);
      return refDeps[name];
    },
    claim: function (ref, name) {
      if (!huggyMap.has(ref)) {
        throw new ReferenceError('No mixin defined.');
      }
      var deps = huggyMap.get(ref);
      if (!deps.hasOwnProperty(name)) {
        throw new ReferenceError('No mixin ' + name + ' defined.');
      }
      return deps[name];
    }
  };
  return huggy;
}


module.exports = factory;
