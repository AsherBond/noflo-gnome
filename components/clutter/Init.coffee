noflo = require 'noflo'
Clutter = imports.gi.Clutter

class Init extends noflo.Component
  description: 'Init the Clutter framework'
  constructor: ->
    @inPorts = new noflo.InPorts
      in:
        datatype: 'bang'
        description: ''
        required: true
    @outPorts = new noflo.OutPorts
      out:
        datatype: 'bang'
        description: ''
        required: false

    @inPorts.in.on 'data', (data) =>
      Clutter.init null, null
      @outPorts.out.send true
      @outPorts.out.disconnect()

exports.getComponent = -> new Init
