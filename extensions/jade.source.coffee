
SourceFile  = require '..'
jade        = require 'jade'
fs          = require 'fs'

class JadeSourceFile extends SourceFile
  constructor: (path, options) ->
    options = Object.merge options, JadeSourceFile.defaults, false
    options = Object.merge JadeSourceFile.overrides, options, false
    
    super path, options

  compile: (path) ->
    fs.readFile path, 'utf8', (err, contents) =>
      return @emit 'error', err if err
      @emit 'compiled', (jade.compile contents, filename: path), path, path.replace JadeSourceFile.match, JadeSourceFile.extension

JadeSourceFile.match      = /\.jade$/
JadeSourceFile.extension  = '.jtpl'
JadeSourceFile.overrides  =
  timeout: 100


module.exports = JadeSourceFile
