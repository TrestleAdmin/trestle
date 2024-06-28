import ApplicationController from './application_controller'
import usePhotoSwipe from '../mixins/photoswipe'

import PhotoSwipeLightbox from 'photoswipe/lightbox'

export default class extends ApplicationController {
  static targets = ["image"]

  static values = {
    animationType: { type: String, default: 'zoom' },
    animationDuration: { type: Number, default: 150 },
    padding: { type: Object, default: { top: 20, bottom: 20, left: 20, right: 20 } }
  }

  initialize () {
    usePhotoSwipe(this)
  }

  connect () {
    this.lightbox = new PhotoSwipeLightbox(this.options)

    this.lightbox.addFilter('domItemData', (itemData, element, linkEl) => {
      if (linkEl) {
        const width = linkEl.dataset.width
        const height = linkEl.dataset.height

        if (width) itemData.w = width
        if (height) itemData.h = height
      }

      return itemData
    })

    this.lightbox.init()
  }

  disconnect () {
    this.lightbox.destroy()
  }

  get options () {
    return {
      gallery: this.element,
      pswpModule: this.loadPhotoSwipe,

      padding: this.paddingValue,

      showHideAnimationType: this.animationTypeValue,
      showAnimationDuration: this.animationDurationValue,
      hideAnimationDuration: this.animationDurationValue
    }
  }
}
