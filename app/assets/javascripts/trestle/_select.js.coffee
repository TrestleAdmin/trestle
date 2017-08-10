Trestle.ready ->
  $('select[data-enable-select2]').each ->
    $(this).select2
      theme: 'bootstrap'
      containerCssClass: ':all:'
      dropdownCssClass: (el) ->
        el[0].className.replace(/\s*form-control\s*/, '')
