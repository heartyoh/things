# ==========================================
# Copyright 2014 Hatio, Lab.
# Licensed under The MIT License
# http://opensource.org/licenses/MIT
# ==========================================

define [
  'lodash'
  '../group/Group'
  '../shape/Circle'
], (
  _
  Group
  Circle
) ->

  'use strict'

  class P2PHandle extends Group

    align: ->
      points = [
        [
          @target.get('x1')
          @target.get('y1')
        ]
        [
          @target.get('x2')
          @target.get('y2')
        ]
      ]

      @forEach (component) ->
        index = component.get('index')
        component.set
          cx: points[index][0]
          cy: points[index][1]

    setup: ->
      @set('clip', false)

      @target = @select(@get('target'))[0]

      for i in [0..1]
        @build
          type: 'circle'
          attrs:
            x: 0
            y: 0
            r: 5
            index: i
            fillStyle: 'white'
            strokeStyle: 'black'
            lineWidth: 1
            draggable: true

      @align()

    onchange: (e) ->
      @align()
      @draw()

    ondragstart: (e) ->

    ondrag: (e) ->

    ondragend: (e) ->

    event_map: ->
      '?target':
        '?target':
          change: @onchange
      '(self)':
        'circle':
          dragstart: @ondragstart
          drag: @ondrag
          dragend: @ondragend

    @spec:
      type: 'p2p-handle'

      containable: false

      description: 'Point-to-Point Handle'

      dependencies: {
        'circle': Circle
      }

      properties: [
        {
          target:
            type: 'string'
        }
      ]
