/* global Turbolinks */

import turbolinks from './turbolinks'

// The visit function is used to direct the user to the given URL. It is provided as an abstraction as the redirection
// is handled differently depending on whether or not Turbolinks is enabled.
//
//     Trestle.visit("/admin/pages");
//
export default function (url) {
  if (turbolinks) {
    Turbolinks.visit(url)
  } else {
    document.location = url
  }
}
