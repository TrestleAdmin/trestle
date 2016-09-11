Trestle.ready ->
  # This must be bound to an element beneath document so
  # that it is fired before any jquery_ujs events.
  root = $('body')

  root.confirmation
    rootSelector:   'body'
    selector:       '[data-toggle="confirm-delete"]'
    singleton:      true
    popout:         true
    btnOkIcon:      ''
    btnOkClass:     'btn-danger'
    btnOkLabel:     'Delete'
    btnCancelIcon:  ''
    btnCancelClass: 'btn-default'
    btnCancelLabel: 'Cancel'
    copyAttributes: ''

  root.on 'click', '[data-toggle="confirm-delete"]', (e, ack) ->
    unless ack
      e.preventDefault()
      e.stopPropagation()
      e.stopImmediatePropagation()
