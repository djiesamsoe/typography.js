React = require 'react'
Reflux = require 'reflux'
objectAssign = require 'object-assign'
Actions = require './Actions'
Immutable = require 'immutable'
qs = require 'qs'
_ = require 'underscore'
$ = require 'jquery'

Typography = require '../src/'

# Parse query string to get any overrides to default typography
overrides = qs.parse(location.hash.slice(3))

# Load any fonts.
if overrides.googleHeaderFont?
  result = Typography({
    googleFonts: [
      {
        name: overrides.googleHeaderFont
        styles: [
          "100"
          "300"
          "400"
          "700"
          "900"
        ]
      }
    ]
  })

  $('head').append(React.renderToStaticMarkup(result.GoogleFont()))

if overrides.googleBodyFont? and
    overrides.googleBodyFont isnt overrides.googleHeaderFont
  result = Typography({
    googleFonts: [
      {
        name: overrides.googleBodyFont
        styles: [
          "100"
          "300"
          "400"
          "700"
          "900"
        ]
      }
    ]
  })

  $('head').append(React.renderToStaticMarkup(result.GoogleFont()))

config = Immutable.Map(overrides)
typography = Typography(config.toJS())
document.getElementById("react-typography").innerHTML = typography.styles

module.exports = Reflux.createStore

  init: ->
    @listenTo Actions.configChange, @handleChange

  handleChange: (change, component) ->
    oldConfig = config
    config = config.merge change
    if config isnt oldConfig

      # Update query string
      component.replaceWith('/', null, config.toJS())

      # Recalculate typography
      typography = Typography(config.toJS())
      document.getElementById("react-typography").innerHTML = typography.styles
      @trigger typography

  getInitialState: ->
    typography
