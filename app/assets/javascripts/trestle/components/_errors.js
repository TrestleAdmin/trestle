// Add error indicators to tabs
Trestle.ready(function() {
  $('.tab-pane').each(function() {
    var errorCount = $(this).find('.has-error').length;

    if (errorCount > 0) {
      var indicator = $("<span>").addClass('label label-danger label-pill').text(errorCount);
      $(".nav-tabs a[href='#" + $(this).attr('id') + "']").append(indicator);
    }
  });
});
