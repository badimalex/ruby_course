# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $('body').on 'click', '.edit-answer-link', ->
    event.preventDefault();
    $(this).hide();
    answer_id = $(this).data('answer-id')
    $('form#edit-answer-' + answer_id).show();
