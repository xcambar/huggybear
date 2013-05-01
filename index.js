"use strict";
require('es6-shim');

var huggyMap = new Map();

var slice = Array.prototype.slice;

module.exports = {
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
    if (!refDeps[name]) {
      refDeps[name] = require(name).apply(undefined, args);
    }
    return refDeps[name];
  }
};

