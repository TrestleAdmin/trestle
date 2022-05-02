import ApplicationController from './application_controller'

import $ from 'jquery'
import 'magnific-popup'

export default class extends ApplicationController {
  static targets = ["image"]

  connect () {
    $(this.lightboxTarget).magnificPopup(this.options)
  }

  get lightboxTarget () {
    if (this.hasImageTarget) {
      return this.imageTargets
    } else {
      return this.element
    }
  }

  get options () {
    return {
      type: 'image',
      closeOnContentClick: false,
      closeBtnInside: false,
      mainClass: 'mfp-with-zoom mfp-img-mobile',
      zoom: {
        enabled: true,
        duration: 150
      }
    }
  }
}
