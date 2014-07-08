# ==========================================
# Copyright 2014 Hatio, Lab.
# Licensed under The MIT License
# http://opensource.org/licenses/MIT
# ==========================================

define [
  '../../Shape'
  '../handle/BoundHandle'
  '../handle/RotationHandle'
  '../../validator/Bound'
  '../../validator/Graphic'
], (
  Shape
  BoundHandle
  RotationHandle
  Bound
  Graphic
) ->

  "use strict"

  class ImageBox extends Shape

    capture_shape: (context) ->

      context.rect @get('x'), @get('y'), @get('w') || @image.width, @get('h') || @image.height

    onadded: (container) ->
      @image = new Image()

      self = @
      @image.onload = ->
        self.draw()

      @image.src = @get('src')

    shape: (context) ->
      return unless @image

      context.drawImage @image, @get('x'), @get('y'), @get('w') || @image.width, @get('h') || @image.height

    bound: ->
      {
        x: @get('x')
        y: @get('y')
        w: @get('w') || @image.width
        h: @get('h') || @image.height
      }

    handles: ->
      ['bound-handle', 'rotation-handle']

    event_map: ->
      map =
        '(self)':
          '(self)':
            change: (component, before, after) ->
              return unless after.hasOwnProperty('src')

              @image.src = after['src']

    @spec:
      type: 'image'

      source: 'core:shape.ImageBox'

      containable: false

      description: 'ImageBox'

      dependencies: {
        'bound-handle': BoundHandle
        'rotation-handle': RotationHandle
      }

      properties: [
        Bound
        Graphic
        {
          src:
            type: 'string'
        }
      ]
