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

  show: (tweet)->
    container = $("<div>")
    container.data("tweet", tweet)
    icon = $("<div>")
    icon.addClass("icon")
    img = $("<img>")
    img.attr "src", tweet.user.profile_image_url_https
    icon.append img
    container.append icon
    message = $("<p>")
    message.text tweet.text
    container.append message
    @tweetsList.prepend container
    container.css({height: "0px"})
    container.animate({height: "48px"})
  initialize: ->
    super

    self = this

    @T = new Twit({
        consumer_key:         atom.config.get('twitter.consumer_key')
      , consumer_secret:      atom.config.get('twitter.consumer_secret')
      , access_token:         atom.config.get('twitter.access_token')
      , access_token_secret:  atom.config.get('twitter.access_token_secret')
    })

    @tweetsList.on "click", "> div > .icon", (event)->
      tweet = $(this).parent().data("tweet")
      self.T.post 'favorites/create', {id: tweet.id_str}, (err, data, response)->
        console.log arguments
    @tweetsList.on "mouseover", "> div > p", (event)->
      height = this.scrollHeight
      $(this).parent().animate({height: height+3})
    @tweetsList.on "mouseout", "> div > p", ->
      $(this).parent().animate({height: "48px"})

    @stream = @T.stream('user')
    @stream.on 'tweet', (tweet)=>
      @show(tweet)

    @T.get 'statuses/home_timeline', { count: 200 }, (err, data, response)=>
      for tweet in data
        @show(tweet)


    atom.workspaceView.command "twitter:timeline:toggle", => @toggle()

  toggle: ->
    console.log "TwitterTimelineView was toggled!"
    if @hasParent()
      @detach()
    else
      atom.workspaceView.appendToRight(this)
