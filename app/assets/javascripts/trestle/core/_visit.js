// The visit function is used to direct the user to the given URL. It is provided as an abstraction as the redirection
// is handled differently depending on whether or not Turbolinks is enabled.
//
//     Trestle.visit("/admin/pages");
//
if (Trestle.turbolinks) {
  Trestle.visit = function(url) { Turbolinks.visit(url); };
} else {
  Trestle.visit = function(url) { document.location = url; };
}
