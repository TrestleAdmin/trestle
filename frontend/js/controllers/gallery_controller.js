import LightboxController from './lightbox_controller'

export default class extends LightboxController {
  get options () {
    return {
      ...super.options,

      gallery: {
        enabled: true
      }
    }
  }
}
