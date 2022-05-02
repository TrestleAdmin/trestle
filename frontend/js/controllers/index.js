import { Application } from '@hotwired/stimulus'
import { definitionsFromContext } from '@hotwired/stimulus-webpack-helpers'

import ApplicationController from './application_controller'

window.Stimulus = Application.start()

const context = require.context('.', true, /\.js$/)
const controllerDefinitions = definitionsFromContext(context)
Stimulus.load(controllerDefinitions)

const Controllers = controllerDefinitions.reduce((result, definition) => {
  return { ...result, [definition.identifier]: definition.controllerConstructor }
}, {})

export {
  ApplicationController,
  Controllers
}
