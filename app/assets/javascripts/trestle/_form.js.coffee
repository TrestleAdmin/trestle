# Prevent enter key from submitting the form
$(document).on 'keydown', '.app-main form', (e) ->
  if e.keyCode == 13
    e.preventDefault()
