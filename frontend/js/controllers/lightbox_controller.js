import ApplicationController from './application_controller'
import usePhotoSwipe from '../mixins/photoswipe'

import PhotoSwipeLightbox from 'photoswipe/lightbox'
import getVideoId from 'get-video-id'

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

const VideoIframeUrl = {
  youtube: (id) => `https://www.youtube.com/embed/${id}`,
  vimeo: (id) => `https://player.vimeo.com/video/${id}`
}

export default class extends ApplicationController {
  static values = {
    animationType: { type: String, default: 'zoom' },
    animationDuration: { type: Number, default: 150 },
    padding: { type: Object, default: { top: 20, bottom: 20, left: 20, right: 20 } },

    defaultVideoWidth: { type: Number, default: 800 },
    defaultVideoHeight: { type: Number, default: 450 }
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
    this.lightbox.on('contentActivate', this.contentActivateHandler.bind(this))
    this.lightbox.on('contentDeactivate', this.contentDeactivateHandler.bind(this))

    this.lightbox.addFilter('domItemData', this.domItemDimensionsFilter.bind(this))
    this.lightbox.addFilter('domItemData', this.domItemVideoFilter.bind(this))
    this.lightbox.addFilter('domItemData', this.domItemEmbedFilter.bind(this))
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

  // Append HTML slide content when slide is reactivated
  contentActivateHandler({ content }) {
    if (content.type == 'html') {
      content.append()
    }
  }

  // Remove HTML slide content when slide is deactivated
  contentDeactivateHandler ({ content }) {
    if (content.type == 'html') {
      content.remove()
    }
  }

  // Sets the width and height from data-width and data-height attributes on the link element
  domItemDimensionsFilter (itemData, element, linkEl) {
    if (linkEl) {
      const width = linkEl.dataset.width
      const height = linkEl.dataset.height

      if (width) itemData.w = Number(width)
      if (height) itemData.h = Number(height)
    }

    return itemData
  }

  // Use <video> tag to play media when data-type="video"
  domItemVideoFilter (itemData, element, linkEl) {
    if (linkEl && linkEl.dataset.type == 'video') {
      itemData.type = 'html'
      itemData.html = `<video controls><source src="${itemData.src}"></video>`

      this.#setDefaultVideoDimensions(itemData)
    }

    return itemData
  }

  // Automatically detect video links and convert to an iframe
  domItemEmbedFilter (itemData, element, linkEl) {
    if (linkEl && !itemData.type) {
      const video = getVideoId(itemData.src)

      if (video.service && VideoIframeUrl[video.service]) {
        const src = VideoIframeUrl[video.service](video.id)

        itemData.type = 'html'
        itemData.html = `<iframe src="${src}" allowfullscreen></iframe>`

        this.#setDefaultVideoDimensions(itemData)
      }
    }

    return itemData
  }

  // Use the thumbnail as the content placeholder only when an explicit width/height is set
  useContentPlaceholderFilter (useContentPlaceholder, content) {
    return content.width && content.height && content.type !== 'html'
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

  #setDefaultVideoDimensions(itemData) {
    itemData.w ||= this.defaultVideoWidthValue
    itemData.h ||= this.defaultVideoHeightValue
  }
}
