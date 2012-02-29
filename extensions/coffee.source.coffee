
SourceFile  = require '..'
coffee      = require 'coffee-script'
fs          = require 'fs'

class CoffeeSourceFile extends SourceFile
  constructor: (path, options) ->
    options = Object.merge options, CoffeeSourceFile.defaults, false
    options = Object.merge CoffeeSourceFile.overrides, options, false
    
    super path, options

  compile: (path) ->
    fs.readFile path, 'utf8', (err, contents) =>
      return @emit 'error', err if err
      try
        js = coffee.compile contents
      catch e
        return @emit 'error', e
      @emit 'compiled', js, path, path.replace CoffeeSourceFile.match, CoffeeSourceFile.extension


CoffeeSourceFile.match      = /\.coffee$/
CoffeeSourceFile.extension  = '.js'
CoffeeSourceFile.overrides  =
  timeout: 100


module.exports = CoffeeSourceFile