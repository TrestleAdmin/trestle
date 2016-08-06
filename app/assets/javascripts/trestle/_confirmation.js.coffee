Trestle.ready ->
  $('[data-toggle="confirm-delete"]').confirmation
    singleton:      true
    popout:         true
    btnOkIcon:      ''
    btnOkClass:     'btn-danger'
    btnOkLabel:     "Delete"
    btnCancelIcon:  ''
    btnCancelClass: 'btn-default'
    btnCancelLabel: 'Cancel'
    copyAttributes: ''
