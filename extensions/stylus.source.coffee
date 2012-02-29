
SourceFile  = require '..'
stylus      = require 'stylus'
fs          = require 'fs'

class StylusSourceFile extends SourceFile
  constructor: (path, options) ->
    options = Object.merge options, StylusSourceFile.defaults, false
    options = Object.merge StylusSourceFile.overrides, options, false
    
    super path, options

  compile: (path) ->
    fs.readFile path, 'utf8', (err, contents) =>
      return @emit 'error', err if err
      stylus.render contents, filename: path, (err, css) =>
        return @emit 'error', err if err
        @emit 'compiled', css, path, path.replace StylusSourceFile.match, StylusSourceFile.extension

StylusSourceFile.match      = /\.styl$/
StylusSourceFile.extension  = '.css'
StylusSourceFile.overrides  =
  timeout: 100

module.exports = StylusSourceFile
