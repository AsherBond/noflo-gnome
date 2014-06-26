noflo = require 'noflo'
Lang = imports.lang

class ListenProperty extends noflo.Component
  description: 'Listen to a signal on a given object'
  icon: 'bolt'
  constructor: ->
    @inPorts = new noflo.InPorts
      object:
        datatype: 'object'
        description: 'Object instance to listen at'
        required: yes
      property:
        datatype: 'string'
        description: 'Property change to listen to'
        required: yes
      readback:
        datatype: 'boolean'
        description: 'Initial value readback'
        required: no
    @outPorts = new noflo.OutPorts
      object:
        datatype: 'object'
        description: 'Object been listen to'
        required: no
      value:
        datatype: 'all'
        description: 'Property value'
        required: no

    @inPorts.readback.on 'data', (@readback) =>
    noflo.helpers.WirePattern @,
      in: ['object', 'property']
      out: []
      forwardGroups: false,
      (data, groups, out) =>
        @updateListener(data.object, data.property)

  updateListener: (object, property) ->
    @disconnectListener()
    @object = object
    @property = property
    @listener = @object.connect "notify::#{@property}", Lang.bind @, () =>
      @sendOutputs()
    @sendOutputs() if @readback

  sendOutputs: () ->
    @outPorts.object.send @object
    @outPorts.object.disconnect()
    @outPorts.value.send @object[@property]
    @outPorts.value.disconnect()

  disconnectListener: () ->
    if @listener
      @object.disconnect @listener
      delete @listener

  shutdown: () ->
    @disconnectListener()

exports.getComponent = -> new ListenProperty
