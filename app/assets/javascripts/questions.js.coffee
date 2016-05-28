# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $('body').on 'click', '.edit-question-link', ->
    event.preventDefault();
    $(this).hide();
    $('form#edit-question').show();

  $('.upvote').bind 'ajax:success', (e, data, status, xhr) ->
    votable = $.parseJSON(xhr.responseText)
    $('.vote-count-post').html(votable.score)
