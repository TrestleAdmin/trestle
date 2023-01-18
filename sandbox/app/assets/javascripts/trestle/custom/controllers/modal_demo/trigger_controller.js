var ModalDemo = ModalDemo || {}
ModalDemo.TriggerController = class extends Trestle.ApplicationController {
  static targets = ['status']

  connect () {
    this.setStatus('ModalDemo.Trigger controller initialized.')
  }

  setStatus (message) {
    this.statusTarget.innerText = message
  }

  setLoading () {
    this.setStatus('Loading modal...')
  }

  setLoaded () {
    this.setStatus('Modal successfully loaded.')
  }

  updateStatus (e) {
    this.setStatus(`Modal submitted with: ${e.detail.message}`)
  }
}
