import $ from 'jquery'

import { init } from '../core/events'

init(function (root) {
  $(root).find('[data-behavior~="zoom"]').magnificPopup({
    type: 'image',
    closeOnContentClick: false,
    closeBtnInside: false,
    mainClass: 'mfp-with-zoom mfp-img-mobile',
    zoom: {
      enabled: true,
      duration: 150
    }
  })

  $(root).find('[data-behavior~="gallery"]').each(function () {
    $(this).magnificPopup({
      delegate: 'a',
      type: 'image',
      closeOnContentClick: false,
      closeBtnInside: false,
      mainClass: 'mfp-with-zoom mfp-img-mobile',
      gallery: {
        enabled: true
      },
      zoom: {
        enabled: true,
        duration: 150
      }
    })
  })
})
