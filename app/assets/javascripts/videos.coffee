# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  createStoryJS
    type: 'timeline'
    width: '400'
    height: '500'
    source: '/timeline_events'
    embed_id: 'timeline'

