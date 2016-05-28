$ ->
  $('.upvote').bind 'ajax:success', (e, data, status, xhr) ->
    counter = $(e.target).parents('.voting').find('.vote-score')
    votable = $.parseJSON(xhr.responseText)
    $(counter).html(votable.score)
