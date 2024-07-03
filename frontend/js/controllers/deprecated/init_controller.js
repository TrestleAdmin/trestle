import { Controller } from '@hotwired/stimulus'

import { triggerInit } from '../../deprecated/events'

export default class extends Controller {
  connect () {
    triggerInit(this.element)
  }
}
