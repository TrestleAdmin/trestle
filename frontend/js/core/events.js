import $ from 'jquery'

import turbolinks from './turbolinks'

// The ready function sets up a callback to run on each page load.
//
//     Trestle.ready(function() {
//       ...
//     });
//
const readyCallbacks = $.Callbacks('unique')
export function ready (callback) {
  readyCallbacks.add(callback)
}

export function triggerReady (root) {
  readyCallbacks.fire(root)
}

// The init function sets up a callback to run on each page load, as well as when elements are added to the page
// dynamically (e.g. via a modal). It is used to initialize dynamic elements such as date pickers, although it is
// preferable if they can be set up using event delegation on the document element.
//
// The callback is triggered with the applicable root/container element as the argument.
//
//     Trestle.init(function(root) {
//       $(root).find('...');
//     });
//
const initCallbacks = $.Callbacks('unique')
export function init (callback) {
  initCallbacks.add(callback)
}

export function triggerInit (root) {
  // Pass root as both parameters for backwards compatibility
  initCallbacks.fire(root, root)
}

// Initialize all elements within the document on page load.
ready(function () {
  triggerInit(document)
})

// Trigger the page load events.
if (turbolinks) {
  $(document).on('turbolinks:load', triggerReady)
} else {
  $(document).ready(triggerReady)
}
