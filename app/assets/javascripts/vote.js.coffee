$(document).bind 'ajax:success', (e, data, status, xhr) ->
  up_votes = $(e.target).parents('.vote').find('.vote-up-votes')
  down_votes = $(e.target).parents('.vote').find('.vote-down-votes')
  voteable = $.parseJSON(xhr.responseText)
  $(up_votes).html(voteable.up_votes)
  $(down_votes).html(voteable.down_votes)
.bind 'ajax:error', (e, xhr, status, error) ->
  voging_error = $(e.target).parents('.vote').find('.errors')
  response = $.parseJSON(xhr.responseText)
  voging_error.html(response.error)
