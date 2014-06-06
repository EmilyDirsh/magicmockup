fs = require 'fs'
exec = require('child_process').exec

task 'build', 'Build magicmockup', () ->
  console.log 'Compiling magicmockup.coffee'
  exec 'coffee -cp magicmockup.coffee', (error, stdout, stderr) ->
    if error?
      console.log 'There was an error in exec', error
