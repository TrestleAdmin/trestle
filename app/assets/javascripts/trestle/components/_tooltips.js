Trestle.init(function(e, root) {
  $(root).find('[data-toggle="tooltip"]').tooltip();
});

if (!('ontouchstart' in window)) {
  Trestle.ready(function() {
    $(document).tooltip({
      selector:  '.app-nav a',
      trigger:   'hover',
      placement: 'right',
      container: 'body',
      template:  '<div class="tooltip nav-tooltip" role="tooltip"><div class="tooltip-arrow"></div><div class="tooltip-inner"></div></div>',
      title: function() {
        return $(this).find('.nav-label').text();
      }
    });
  });
};
