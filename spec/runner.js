"use strict";



var specFiles = ['index.coffee'];




require('coffee-script-redux');
var mocha = new (require('mocha'))();
mocha.reporter('spec');
mocha.files = specFiles.map(function (f) {
  return [__dirname, f].join('/');
});
mocha.run();
