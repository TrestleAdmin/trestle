//= require trestle/jquery
//= require trestle/jquery_ujs
//= require trestle/bootstrap
//= require trestle/bootstrap-confirmation
//= require trestle/magnific-popup
//= require trestle/flatpickr
//= require trestle/select2
//
//= require_self
//
//= require_tree ./core
//= require_tree ./components
//
//= require trestle/custom

var Trestle = {
  // Is Turbolinks enabled?
  turbolinks: typeof(Turbolinks) !== 'undefined' && Turbolinks.supported,

  // Store for i18n translations used within JS
  i18n: {}
};

window.Trestle = Trestle;
