Trestle.confirmation = {};

Trestle.confirmation.DEFAULTS = {
  rootSelector:   'body',
  singleton:      true,
  popout:         true,
  title:          Trestle.i18n['admin.confirmation.title'] || 'Are you sure?',
  btnOkIcon:      '',
  btnOkClass:     'btn-primary',
  btnOkLabel:     Trestle.i18n['admin.confirmation.ok'] || 'OK',
  btnCancelIcon:  '',
  btnCancelClass: 'btn-default',
  btnCancelLabel: Trestle.i18n['admin.confirmation.cancel'] || 'Cancel',
  copyAttributes: ''
};

Trestle.confirmation.CONFIRM = $.extend({}, Trestle.confirmation.DEFAULTS, {
  selector: '[data-toggle="confirm"]'
});

Trestle.confirmation.DELETE = $.extend({}, Trestle.confirmation.DEFAULTS, {
  selector:   '[data-toggle="confirm-delete"]',
  btnOkClass: 'btn-danger',
  btnOkLabel: Trestle.i18n['admin.confirmation.delete'] || 'Delete'
});

Trestle.ready(function() {
  // This must be bound to an element beneath document so
  // that it is fired before any jquery_ujs events.
  var root = $('body');

  // Ensure it is only initialized once
  if (root.data('bs.confirmation')) return;

  // Delete confirmation
  new $.fn.confirmation.Constructor(root, Trestle.confirmation.DELETE);

  // General confirmation
  new $.fn.confirmation.Constructor(root, Trestle.confirmation.CONFIRM);
});
