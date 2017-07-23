Trestle.ready ->
  # This must be bound to an element beneath document so
  # that it is fired before any jquery_ujs events.
  root = $('body')

  root.confirmation
    rootSelector:   'body'
    selector:       '[data-toggle="confirm-delete"]'
    singleton:      true
    popout:         true
    title:          Trestle.i18n['admin.confirmation.title']
    btnOkIcon:      ''
    btnOkClass:     'btn-danger'
    btnOkLabel:     Trestle.i18n['admin.confirmation.delete'] || 'Delete'
    btnCancelIcon:  ''
    btnCancelClass: 'btn-default'
    btnCancelLabel: Trestle.i18n['admin.confirmation.cancel'] || 'Cancel'
    copyAttributes: ''
