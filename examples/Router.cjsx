React = require 'react'
Router = require 'react-router'
Reflux = require 'reflux'
{Container} = require 'react-responsive-grid'
{Route, Navigation, DefaultRoute, RouteHandler, Link} = Router

TypographyStore = require './TypographyStore'
Typography = require '../src/'
typography = Typography()
{GoogleFont, TypographyStyle, HTMLStyle, rhythm} = typography
Styleguide = require './Styleguide'
Configuration = require './Configuration'
Controls = require './Controls'

App = React.createClass
  mixins: [Reflux.connect(TypographyStore, 'typography')]

  getInitialState: ->
    configState: {}

  render: ->
    unless @state.typography
      <div />
    else
      rhythm = @state.typography.rhythm
      <div>
        <div style={{
          background: '#E3F2FD'
          height: "100vh"
          left: 0
          padding: 24
          paddingTop: 48
          position: "fixed"
          width: 280
        }}>
          <Controls typography={@state.typography}/>
        </div>
        <Container style={{
          maxWidth: 768
          padding: rhythm(1)
          paddingLeft: "calc(280px + 24px*2 + #{rhythm(1.5)})"
        }}>
          <RouteHandler/>
        </Container>
      </div>

routes = (
  <Route handler={App}>
    <DefaultRoute handler={Styleguide}/>
    <Route name="configuration" path="/configuration" handler={Configuration}/>
  </Route>
)

Router.run(routes, (Handler) ->
  React.render(<Handler/>, document.getElementById("mount-point"))
)
