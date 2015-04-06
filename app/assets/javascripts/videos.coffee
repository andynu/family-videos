# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  testTimeline =
    timeline:
        headline: 'test'
        type: 'default'
        text: 'intro text'
        date: [
          {
            startDate: "2015,1,1"
            text: "test event"
          }
        ]
          
  createStoryJS
    type: 'timeline'
    width: '400'
    height: '500'
    source: testTimeline
    embed_id: 'timeline'

