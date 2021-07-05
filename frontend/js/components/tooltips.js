import $ from 'jquery'

import { init, ready } from '../core/events'

// Enable general tooltips and popovers
init(function (root) {
  $(root).find('[data-bs-toggle="tooltip"]').tooltip()
  $(root).find('[data-bs-toggle="popover"]').popover()
})

// Enable navigation tooltips for non-touch devices
if (!('ontouchstart' in window)) {
  ready(function () {
    $('body').tooltip({
      selector: '.app-nav a',
      trigger: 'hover',
      placement: 'right',
      boundary: 'window',
      template: '<div class="tooltip nav-tooltip" role="tooltip"><div class="tooltip-arrow"></div><div class="tooltip-inner"></div></div>',
      title: function () {
        return $(this).find('.nav-label').text()
      }
    })
  })
};
