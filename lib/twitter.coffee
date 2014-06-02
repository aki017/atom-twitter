TwitterView = require './twitter-view'
TwitterTimelineView = require './twitter-timeline-view'

module.exports =
  twitterView: null
  twitterTimelineView: null
  configDefaults: {
    consumer_key:         'bNW1xolDbqtJM1T25lt1PVHvH'
    consumer_secret:      '96IfEqTjkRLjToDI5W3EPv3qb8FcGexRG7NwAQh3ZH7CKgJt7e'
    access_token:         ''
    access_token_secret:  ''
  },

  activate: (state) ->
    @twitterView = new TwitterView(state.twitterViewState)
    @twitterTimelineView = new TwitterTimelineView(state.twitterViewState)

  deactivate: ->
    @twitterView.destroy()
    @twitterTimelineView.destroy()

  serialize: ->
    twitterViewState: @twitterView.serialize()
    twitterTimelineViewState: @twitterTimelineView.serialize()
