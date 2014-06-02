{$, ScrollView, EditorView} = require 'atom'
Twit = require 'twit'

module.exports =
class TwitterTimelineView extends ScrollView
  @content: ->
    @div class: 'twitter editor-colors', =>
      @div class: 'main-container', =>
        @form submit: "onSubmit", =>
          @div class: 'controls', =>
            @div class: 'editor-container', =>
              @subview "test", new EditorView(mini: true, attributes: {id: "test", type: "string"}, placeholderText: "今なにしてる？")
      @div outlet: "tweetsList", class: "tweets-list"

  onSubmit: (event, element)->
    status = element.find("input[type=text]").val()
    for editorView in @find('.editor[id]').views()
      do (editorView) =>
        status = editorView.getText()
        editorView.setText("")
    @T.post 'statuses/update', { status: status }, (err, data, response)->
      console.log arguments
    false
  initialize: ->
    super

    @T = new Twit({
        consumer_key:         atom.config.get('twitter.consumer_key')
      , consumer_secret:      atom.config.get('twitter.consumer_secret')
      , access_token:         atom.config.get('twitter.access_token')
      , access_token_secret:  atom.config.get('twitter.access_token_secret')
    })

    @stream = @T.stream('user')
    @stream.on 'tweet', (tweet)=>
      container = $("<div>")
      img = $("<img>")
      img.attr "src", tweet.user.profile_image_url_https
      container.append img
      message = $("<p>")
      message.text tweet.text
      container.append message
      @tweetsList.prepend container


    @T.get 'statuses/home_timeline', { count: 200 }, (err, data, response)=>
      for tweet in data
        container = $("<div>")
        img = $("<img>")
        img.attr "src", tweet.user.profile_image_url_https
        container.append img
        message = $("<p>")
        message.text tweet.text
        container.append message
        @tweetsList.prepend container


    atom.workspaceView.command "twitter:timeline:toggle", => @toggle()

  toggle: ->
    console.log "TwitterTimelineView was toggled!"
    if @hasParent()
      @detach()
    else
      atom.workspaceView.appendToRight(this)
