Trestle.ready(function() {
  $('select[data-enable-select2]').each(function() {
    $(this).select2({
      theme: 'bootstrap',
      containerCssClass: ':all:',
      dropdownCssClass: function(el) {
        return el[0].className.replace(/\s*form-control\s*/, '');
      }
    });
  });
});
