import { Popover } from 'bootstrap'

document.addEventListener('turbo:load', function () {
  // eslint-disable-next-line no-new
  new Popover(document.body, {
    selector: '[data-toggle="popover"]'
  })
})
