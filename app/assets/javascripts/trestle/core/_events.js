// The ready function sets up a callback to run on each page load.
//
//     Trestle.ready(function() {
//       ...
//     });
//
Trestle.ready = function(callback) {
  $(Trestle).on('load', callback);
};

// The init function sets up a callback to run on each page load, as well as when elements are added to the page
// dynamically (e.g. via a modal). It is used to initialize dynamic elements such as date pickers, although it is
// preferable if they can be set up using event delegation on the document element.
//
// The callback is triggered with the applicable root/container element as the second argument.
//
//     Trestle.init(function(e, root) {
//       $(root).find('...');
//     });
//
Trestle.init = function(callback) {
  $(Trestle).on('init', callback);
};

// Initialize all elements within the document on page load.
Trestle.ready(function() {
  $(Trestle).trigger('init', document);
});

// Trigger the page load events.
if (Trestle.turbolinks) {
  $(document).on('turbolinks:load', function() {
    $(Trestle).trigger("load");
  });
} else {
  $(document).ready(function() {
    $(Trestle).trigger("load");
  });
}
