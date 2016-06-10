$ ->
  $('.vote a').bind 'ajax:success', (e, data, status, xhr) ->
    $vote = $(e.target).parents('.vote')
    up_votes = $vote.find('.vote-up-votes')
    down_votes = $vote.find('.vote-down-votes')
    rating = $vote.find('.rating')
    voteable = $.parseJSON(xhr.responseText)
    $(up_votes).html(voteable.up_votes)
    $(down_votes).html(voteable.down_votes)
    $(rating).html(voteable.rating)
  .bind 'ajax:error', (e, xhr, status, error) ->
    voging_error = $(e.target).parents('.vote').find('.errors')
    response = $.parseJSON(xhr.responseText)
    voging_error.html(response.error)
