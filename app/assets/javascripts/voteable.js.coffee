$ ->
  $(document).bind 'ajax:success', (e, data, status, xhr) ->
    counter = $(e.target).parents('.voting').find('.vote-score')
    voteable = $.parseJSON(xhr.responseText)
    $(counter).html(voteable.score)
  .bind 'ajax:error', (e, xhr, status, error) ->
    voging_error = $(e.target).parents('.voting').find('.voting-errors')
    response = $.parseJSON(xhr.responseText)
    voging_error.html(response.error)