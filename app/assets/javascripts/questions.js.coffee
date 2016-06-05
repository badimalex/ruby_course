# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $('body').on 'click', '.edit-question-link', ->
    event.preventDefault();
    $(this).hide();
    $('form#edit-question').show();

  PrivatePub.subscribe '/questions', (data, channel) ->
    question = $.parseJSON(data['question'])
    $('table.questions').append('<tr>' +
      '<td><a href="/questions/'+question.id+'">' + question.title + '</a></td>' +
      '<td>' + question.body + '</td>' +
      '</tr>')
