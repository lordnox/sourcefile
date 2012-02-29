
# source-file

source-file is a project to automatically recompile sourcefiles used during
development. It exposes each file as an eventemitter that tells you when the
file itself is loaded for the first time or if it is changed.

## How to Install

    npm install sourcefile

## How to use

First, require `sourcefile`:

```js
var Sourcefile = require('sourcefile');
```

Next, attach it to a sourcefile. First we show a jade-template:

```js
// libs needed for the example
var fs    = require('fs'),
    jade  = require('jade');

// vars used
var Template = new Sourcefile('./index.jade'),
    template      = '';

Template.on('loaded', function(path) {
  fs.readFile(path, 'utf8', function(err, contents) {
    template = jade.compile(contents, {filename: path});
  });
});

Template.on('modified', function(path) {
  fs.readFile(path, 'utf8', function(err, contents) {
    template = jade.compile(contents, {filename: path});
  });
});

// Template.on('error', function(error) {}); 
```

## Sugar

There are subclasses defined that will emit an `compiled` event. This will be called
after these subclasses have done their job.

```js
var template = '';
// This will identifiy the file as a jade file and use the callback accordingly
jadeTemplate = new Sourcefile.Jade('./index.jade');
jadeTemplate.on('compiled', function(data) {
  template = data;
});
```

Available are:
 *  jade - Sourcefile.Jade
    > compiled jade template function
 *  stylus - Sourcefile.Stylus
    > compiled stylus css as string
 *  coffee-script - Sourcefile.Coffee
    > compiled coffee-script javascript code as string

```js
var template = '';
// This will identifiy the file as a jade file and use the callback accordingly
Sourcefile.source('./index.jade', function(data) {
  template = data;
});
```

And for even more convenience or because its just stupid to sort everything again later
we can tell the `source`-function what to use

```js
// This will identifiy the file as a jade file and use the callback accordingly
Sourcefile.source('./index.jade', ['coffee', 'stylus'], function(data, path) {
  // fs.writeFile ...
});
```


