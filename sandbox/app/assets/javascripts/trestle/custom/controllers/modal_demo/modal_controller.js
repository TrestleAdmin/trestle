var ModalDemo = ModalDemo || {}
ModalDemo.ModalController = class extends Trestle.ApplicationController {
  static targets = ['message']

  submit () {
    const message = this.messageTarget.value

    if (message.length) {
      this.modalController.submit({ message: message })
    } else {
      alert('Message required.')
    }
  }

  setMessage (e) {
    this.messageTarget.value = e.detail.message
  }

  get modalController () {
    return this.application.getControllerForElementAndIdentifier(this.element, 'modal')
  }
}
