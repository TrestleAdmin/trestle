import LightboxController from './lightbox_controller'

export default class extends LightboxController {
  static targets = ["image"]

  get options () {
    return {
      ...super.options,
      children: this.imageTargets
    }
  }
}
