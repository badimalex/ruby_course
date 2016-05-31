$(document).bind 'ajax:success', (e, data, status, xhr) ->
  counter = $(e.target).parents('.vote').find('.vote-score')
  voteable = $.parseJSON(xhr.responseText)
  $(counter).html(voteable.up_votes)
.bind 'ajax:error', (e, xhr, status, error) ->
  voging_error = $(e.target).parents('.vote').find('.errors')
  response = $.parseJSON(xhr.responseText)
  voging_error.html(response.error)