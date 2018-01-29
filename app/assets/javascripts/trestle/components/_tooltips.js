Trestle.init(function(e, root) {
  $(root).find('[data-toggle="tooltip"]').tooltip();
});

if (!('ontouchstart' in window)) {
  Trestle.ready(function() {
    $(document).tooltip({
      selector:  '.app-nav a',
      trigger:   'hover',
      placement: 'right',
      title:     function() { return $(this).find('.nav-label').text(); }
    });
  });
};
