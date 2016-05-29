$ ->
  $(document).bind 'ajax:success', (e, data, status, xhr) ->
    counter = $(e.target).parents('.voting').find('.vote-score')
    voteable = $.parseJSON(xhr.responseText)
    $(counter).html(voteable.score)
