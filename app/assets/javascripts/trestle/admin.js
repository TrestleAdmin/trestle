//= require trestle/jquery
//= require trestle/jquery_ujs
//= require trestle/bootstrap
//= require trestle/bootstrap-confirmation
//= require trestle/magnific-popup
//= require trestle/flatpickr
//= require trestle/select2
//
//= require_self
//= require trestle/custom
//= require_tree .

var Trestle = window.Trestle = {};

Trestle.i18n = {};

if (typeof(Turbolinks) !== 'undefined' && Turbolinks.supported) {
  Trestle.ready = function(callback) { $(document).on('turbolinks:load', callback); };
  Trestle.visit = function(url) { Turbolinks.visit(url); };
} else {
  Trestle.ready = function(callback) { $(callback); };
  Trestle.visit = function(url) { document.location = url; };
}
