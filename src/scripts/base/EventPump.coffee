# ==========================================
# Copyright 2014 Hatio, Lab.
# Licensed under The MIT License
# http://opensource.org/licenses/MIT
# ==========================================

define [
  '../util/Util'
  './ComponentSelector'
], (
  dou
  ComponentSelector
) ->

  "use strict"

  control = (root, listener, handlers, event, args) ->
    for own selector, event_map of handlers when ComponentSelector.match(selector, event.origin, listener, root)
      for own event_name, handler of event_map when event_name is event.name
        event.listener = listener

        (handler.apply @, args)

  event_handler_fn = ->
    args = arguments
    e = args[args.length - 1]
    eventPump = @eventPump

    for item in eventPump.listeners
      control.call @context, eventPump.deliverer, item.listener, item.clonedHandlers, e, args

  class EventPump
    # Construct a new event pump.
    #
    # @param [Object] deliverer target object to listen events that the object fires or delegates
    #
    constructor: (deliverer) ->
      @setDeliverer(deliverer)
      @listeners = []

    setDeliverer: (deliverer) ->
      @deliverer = deliverer

    start: (context) ->
      @deliverer.on 'all', event_handler_fn, {context: (context || null), eventPump: @}

    stop: ->
      @deliverer.off 'all', event_handler_fn

    on: (listener, handlers) ->
      clonedHandlers = _.clone handlers

      selectors = Object.keys(clonedHandlers)

      for selector in selectors when selector.indexOf('?') == 0
        handler = clonedHandlers[selector]
        variable = selector.substr(1)
        value = listener.get(variable)
        delete clonedHandlers[selector]

        if value
          clonedHandlers[value] = handler
        else
          console.log("EventPump#on", "variable #{selector} is not evaluated on listener")

      @listeners.push
        listener: listener
        handlers: handlers
        clonedHandlers: clonedHandlers

    off: (listener, handlers) ->
      for item, index in @listeners
        if item.listener is listener and (!handlers or item.handlers is handlers)
          @listeners.splice(index, 1)

    clear: ->
      @listeners = []

    dispose: ->
      @stop()
      @clear()

  EventPump
