import ApplicationController from './application_controller'
import usePhotoSwipe from '../mixins/photoswipe'

import PhotoSwipeLightbox from 'photoswipe/lightbox'

const waitForImageDimensions = (element) => {
  return new Promise((resolve, reject) => {
    const timeout = setInterval(() => {
      if (element.naturalWidth && element.naturalHeight) {
        clearInterval(timeout)
        resolve(element)
      }
    }, 0)

    element.addEventListener('error', () => {
      clearInterval(timeout)
      reject(element)
    })
  })
}

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
    this.addFilters()
    this.lightbox.init()
  }

  disconnect () {
    this.lightbox.destroy()
  }

  addFilters () {
    this.lightbox.on('contentLoadImage', this.contentLoadImageHandler.bind(this))

    this.lightbox.addFilter('domItemData', this.domItemDataFilter.bind(this))
    this.lightbox.addFilter('useContentPlaceholder', this.useContentPlaceholderFilter.bind(this))
  }

  // If the image width and height is not set, try to set it as soon
  // as the image element has a naturalWidth/naturalHeight
  contentLoadImageHandler ({ content }) {
    if (content.width == 0 || content.height == 0) {
      const imgEl = content.element
      const linkEl = content.data.element

      waitForImageDimensions(imgEl).then((imgEl) => {
        linkEl.dataset.width = imgEl.naturalWidth
        linkEl.dataset.height = imgEl.naturalHeight

        content.instance.refreshSlideContent(content.index)
      }).catch(() => {})
    }
  }

  // Sets the width and height from data-width and data-height attributes on the link element
  domItemDataFilter (itemData, element, linkEl) {
    if (linkEl) {
      const width = linkEl.dataset.width
      const height = linkEl.dataset.height

      if (width) itemData.w = parseInt(width, 10)
      if (height) itemData.h = parseInt(height, 10)
    }

    return itemData
  }

  // Use the thumbnail as the content placeholder only when an explicit width/height is set
  useContentPlaceholderFilter (useContentPlaceholder, content) {
    return content.width && content.height
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
