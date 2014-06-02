{View} = require 'atom'

module.exports =
class TwitterView extends View
  @content: ->
    @div class: 'twitter overlay from-bottom', =>
      @div "The Twitter package is Alive! It's ALIVE!", class: "message"

  initialize: (serializeState) ->
    atom.workspaceView.command "twitter:toggle", => @toggle()

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @detach()

  toggle: ->
    console.log "TwitterView was toggled!"
    if @hasParent()
      @detach()
    else
      atom.workspaceView.append(this)
