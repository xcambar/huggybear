


specFiles = ['index.coffee']




require 'coffee-script-redux'
mocha = new (require 'mocha')()
mocha.reporter 'spec'
mocha.files = specFiles.map (f)->
  [__dirname, f].join '/'

mocha.run()
