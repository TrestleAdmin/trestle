import { Tooltip } from 'bootstrap'

document.addEventListener('turbo:load', function () {
  new Tooltip(document.body, {
    selector: '[data-bs-toggle="tooltip"]'
  })
})
