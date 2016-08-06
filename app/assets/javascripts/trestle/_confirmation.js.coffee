Trestle.ready ->
  $('[data-toggle="confirm-delete"]').confirmation
    singleton:      true
    popout:         true
    btnOkIcon:      ''
    btnOkClass:     'btn-danger'
    btnOkLabel:     "Delete"
    btnCancelIcon:  ''
    btnCancelLabel: 'Cancel'
    copyAttributes: 'href target data'
