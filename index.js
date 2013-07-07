"use strict";
require('es6-shim');

var slice = Array.prototype.slice;

function _getOrCreateMap (hg, ref) {
  var refDeps;
  if (hg.has(ref)) {
    refDeps = hg.get(ref);
  } else {
    refDeps = {};
    hg.set(ref, refDeps);
  }
  return refDeps;
}

function _existsDep(hg, ref, name) {
  return ref.hasOwnProperty(name) || hg.get('_generic').hasOwnProperty(name);
}


function factory () {
  var huggyMap = new Map();

  huggyMap.set('_generic', {});

  var huggy = {
    provide: function () {
      var args = slice.call(arguments);
      var ref = args.shift();
      var name = args.shift();
      var contents = args.shift();
      var refDeps;

      refDeps = _getOrCreateMap(huggyMap, ref);
      if (_existsDep(huggyMap, refDeps, name)) {
        throw new ReferenceError('The mixin ' + name + ' has already been defined.');
      }

      if (typeof contents === 'undefined') {
        throw new Error('You\'ve declared nothing as the mixin');
      }
      refDeps[name] = contents;
      return refDeps[name];
    },
    claim: function (ref, name) {
      var deps = huggyMap.get(ref) || {};
      var generic;
      if (!_existsDep(huggyMap, deps, name)) {
        throw new ReferenceError('No mixin defined.');
      }
      if (deps.hasOwnProperty(name)) {
        return deps[name];
      } else if ((generic = huggyMap.get('_generic')[name])) {
        return generic(ref);
      }
      throw new ReferenceError('No mixin ' + name + ' defined.');
    },
    generic: function (name, def) {
      if (!(def instanceof Function)) {
        throw new TypeError('Generic dependencies should be provided with a function');
      }
      if (huggyMap.get('_generic').hasOwnProperty(name)) {
        throw new Error('Generic dependency "' + name + '" has already been defined');
      }
      huggyMap.get('_generic')[name] = def;
    }
  };
  return huggy;
}


module.exports = factory;
