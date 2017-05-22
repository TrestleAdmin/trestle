# Add error indicators to tabs
Trestle.ready ->
  $('.tab-pane').each ->
    errorCount = $(this).find('.has-error').length

    if errorCount > 0
      indicator = $("<span>").addClass('label label-danger label-pill').text(errorCount)
      $(".nav-tabs a[href='##{$(this).attr('id')}']").append(indicator)
