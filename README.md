todo_app
===============

In 3 steps, you'll have todo_app up and running in your browser from scratch.

Developing
==========

## 1 - [Installing node.js and NPM](http://nodejs.org/#download)

## 2 - Run Stylus/CoffeeScript compilers

    > make stylus
    > make coffee

This will compile `.styl` *to* `.css` and `.coffee` *to* `.js`.  
File changes will **automatically** be recompiled.

If you encounter SSL problems installing npm modules then tell npm to default to http by setting up a .npmrc:
    > echo "registry = http://registry.npmjs.org/" >> ~/.npmrc

## 3- Run development server

    > make server

In a browser, visit `http://localhost:3000/index-dev.html?mock-data`.  

### Why a server?

**The development server is JUST for live.js/livereload and Chrome**. live.js/livereload uses XHR to automatically reload JavaScript and CSS, Chrome does not allow XHR over the `file://` protocol ([issue 41024](http://code.google.com/p/chromium/issues/detail?id=41024)).


Specs
=====

## Generate specs

    > make specs

## Run specs (in the browser)

If the server isn't running...

    > make server

Visit [http://localhost:3000/spec-runner/index.html]


Deploying Checklist
===================

## 1 - Compile Stylus/CoffeeScript

    > make stylus
    > make coffee

## 2 - Rebuild bootstrap.js and bootstrap.css

    > make clean; make

## 3 - Automated Browser Test

    > make specs

In a browser, go to [http://localhost:3000/spec-runner/index.html].


## 4 - Manual Browser Test

    > make server

In a browser, go to [http://localhost:3000] and spotcheck functionality hasn't regressed.

SublimeText Setup
=================

## 1 - Install this TextMate bundle to get CoffeeScript syntax highlighting:

[https://github.com/jashkenas/coffee-script-tmbundle]

Extract it in "~/Library/Application\ Support/Sublime\ Text\ 2/Packages"

## 2 Install the SublimeLinter from package control

This will show CoffeeeScript syntax errors in the editor.  More information is
available at [https://github.com/Kronuz/SublimeLinter].

Note: the coffee command needs to be in your path for the the SublimeLinter to
work with CoffeeScript.

## 3 Install the Stylus TextMate bundle

    > cp -R node_modules/stylus/editors/Stylus.tmbundle "~/Library/Application\ Support/Sublime\ Text\ 2/Packages"

About and Credits
=================
This project was created to train developers how to use a specific flavor of
creating rich client side applications centered around Backbone.js.  The
technologies attached to the backbone are CoffeeScript, require.js for
modularity, Stylus for styling and Peter Wong's Cell
[https://github.com/peterwmwong/cell] for views.  The todo list application
was ported from Larry Myers' Backbone Koans 
[https://github.com/larrymyers/backbone-koans] which was pure JavaScript and
Backbone.js.
