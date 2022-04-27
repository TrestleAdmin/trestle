import { Tooltip } from 'bootstrap'

document.addEventListener('turbo:load', function () {
  // eslint-disable-next-line no-new
  new Tooltip(document.body, {
    selector: '[data-toggle="tooltip"]'
  })
})
