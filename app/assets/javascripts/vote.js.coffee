$(document).bind 'ajax:success', (e, data, status, xhr) ->
  counter = $(e.target).parents('.vote').find('.vote-score')
  voteable = $.parseJSON(xhr.responseText)
  $(counter).html(voteable.up_votes)