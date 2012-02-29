
{EventEmitter}  = require 'events'
Inotify         = require 'inotify-plusplus'
fs              = require 'fs'
sugar           = require 'sugar'

EXTENSIONS      = __dirname + '/extensions/'

###
  emits:
  - loaded
  - modified
###

class SourceFile extends EventEmitter
  timeout: null
  ###
    Construktor of any sourcefile
    @path     path to monitor, should exists
    @options  options given to this source-file object
  ###
  constructor: (@path, options) ->
    @options = Object.merge options, SourceFile.defaults, false

    directive = 
      access:         false
      attrib:         false
      close_write:    false
      close_nowrite:  false
      close:          false
      open:           false
      moved_from:     false
      moved_to:       false
      move:           false
      create:         false
      "delete":       false
      delete_self:    false
      move_self:      false
      all_events:     false
      modify:         (event) => @modified event
    inotify     = Inotify.create false
    toggleWatch = inotify.watch directive, @path

    @on 'loaded',   => @compile @path
    @on 'modified', => @compile @path
    @emit 'loaded'

  compile: (path) ->

  modified: (event) ->
    if @timeout isnt null
      clearTimeout @timeout 

    @timeout = setTimeout =>
      @emit 'modified', event
    , @options.timeout


SourceFile.defaults =
  timeout: 100

Extensions = {}

fs.readdir EXTENSIONS, (err, files) ->
  throw err if err
  files.each (file) ->
    matches = file.match /^(.*)\.source\.\w+/
    return if not matches

    Extensions[matches[1]] = require EXTENSIONS + file

SourceFile.source = (path, extensions, compiled, options) ->
  if not (extensions instanceof Array)
    options = compiled
    compiled = extensions
    extensions = Object.keys Extensions

  extensions.each (key) ->
    extension = Extensions[key]

    if extension and path.match extension.match
      sourcefile = new extension path, options
      sourcefile.on 'compiled', compiled if compiled
      return sourcefile

  false

module.exports = SourceFile
