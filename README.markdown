# MagicMarkup

## About

Easily create mockups in Inkscape, without jumping through hoops!

This is currently a work-in-progress, but it's starting to work! (:


## Getting Started

To use MagicMockup, simply include the following JavaScript in 
your SVG file (directly between the `<svg>` and `<def>` tags):

    <script xlink:href="magicmockup.js" type="text/ecmascript"/>

If you're using Inkscape 0.48, you can add MagicMockup right in
Inkscape:
 1. Go to File > Document Properties...
 1. Click on the Scripting tab
 1. Enter the path to magicmockup.js in the textbox and click Add
 1. You'll see magicmockup.js added to the list of scripts

Inkscape plays nicely with the script tags, so you only have to
add it once per file, and you can save as much as you want.

To make regions of the document clickable, have each frame as a
layer and give the layer an id. For the clickable shape, add
some directives in the object properties dialog inside of the
"Description" entry.

You invoke a directive as `directive=layerName`, e.g. `next=Layer2`.
You can add multiple directives by putting each directive on a new line.

We currently support the following directives:

* next=layer : Show only the specified layer
* show=layer1,layer2.. : Show the specified layers
* hide=layer1,layer2.. : Hide the specified layers
* toggle=layer1,layer2.. : Toggle the specified layers
* fadeOut=layer[,duration = '.5s'] : fade out the specified layer in the specified duration - duration is a css-compatible time string such as ".5s", or "1s", ".5s" by default

Now, you can make interactive mockups! Also,
clickable areas (buttons, etc.) are indicated by a mouse pointer.

More directives are planned. Stay tuned! We're planning
on adding inter-document linking as well.

## Inkscape template
For your convenience, we've added InteractiveMockup.svg to use as an Inkscape template file. It has the magicmockup.js script tag already included.

To use it, copy the file to the templates folder in your Inkscape user directory.
* on Linux/Mac, it's ./config/inkscape/templates/
* on Windows, it's %APPDATA%\\Inkscape\templates\

Then, when you open Inkscape, go to File > New, and choose InteractiveMockup from the list of presets.

## Developing

MagicMockup is written in CoffeeScript. You'll need CoffeeScript installed to develop.

You may install CoffeeScript either via:

    gem install coffee-script
  
...or...

    npm install coffee-script
  
...Depending on if you are using Ruby & Gem or Node.js & NPM.
j
As CoffeeScript is JavaScript, we suggest installing Node.js and using `npm` for installation.

Build MagicMockup using `coffee -c magicmockup.coffee`

For development, you can run `coffee -cw magicmockup.coffee`, and coffe will watch the file and automatically recompile whenever you make a change.

`test.svg` is a click-through test for the current directives. Open it in your favorite browser and watch the magic happen! If you add new directives to Magic Mockup, make sure you add a test for it as well in `test.svg`

## TODO

* More Directives
* External document links
* Animations
* External directive file (possibly)

More details in our EtherPad discussion:
http://ietherpad.com/g6KdUcpNIH


## Authors
* Máirín Duffy
* Garrett LeSage
* Emily Dirsh
