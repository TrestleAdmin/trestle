import $ from 'jquery'

import { i18n } from '../core/i18n'
import { triggerInit } from '../core/events'

const TEMPLATE = `
<div class="modal fade" tabindex="-1" role="dialog">
  <div class="modal-dialog" role="document">
    <div class="modal-content" data-context>
    </div>
  </div>
</div>
`

function createElement () {
  const $el = $(TEMPLATE).appendTo('body')

  $el.modal({
    show: false,
    focus: false
  })

  // Remove dialog elements once hidden
  $el.on('hidden.bs.modal', function () {
    $el.remove()
  })

  // Restore the next visible modal to the foreground
  $el.on('hide.bs.modal', function () {
    $el.prevAll('.modal.in').last().removeClass('background')
  })

  // Set X-Trestle-Dialog header on AJAX requests initiated from the dialog
  $el.on('ajax:beforeSend', '[data-remote]', function (e) {
    const xhr = e.detail[0]
    xhr.setRequestHeader('X-Trestle-Dialog', true)
  })

  return $el
}

export function showError (title, errorText) {
  const dialog = new Dialog({ modalClass: 'modal-lg' })

  dialog.showError(title, $('<pre>').addClass('exception').text(errorText))
  dialog.show()

  return dialog
}

export default class Dialog {
  constructor (options = {}) {
    this.options = options
    this.$el = createElement()

    if (options.modalClass) {
      this.$el.find('.modal-dialog').addClass(options.modalClass)
    }
  }

  load (url, callback) {
    this.show()
    this.setLoading(true)

    $.ajax({
      url: url,
      dataType: 'html',
      headers: {
        'X-Trestle-Dialog': true
      },
      complete: () => {
        this.setLoading(false)
      },
      success: (content) => {
        this.setContent(content)

        if (callback) {
          callback.apply(this)
        }
      },
      error: (xhr, status, error) => {
        const errorMessage = i18n['trestle.dialog.error'] || 'The request could not be completed.'

        const title = error || errorMessage
        const content = $('<p>').text(errorMessage)

        this.showError(title, content)
      }
    })
  }

  setLoading (loading) {
    this.$el.toggleClass('loading', loading)
  }

  setContent (content) {
    this.$el.find('.modal-content').html(content)
    triggerInit(this.$el)
  }

  showError (title, content) {
    this.$el.addClass('error')

    this.setContent(`
      <div class="modal-header">
        <h4 class="modal-title">${title}</h4>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
      </div>

      <div class="modal-body">
        ${content.prop('outerHTML')}
      </div>

      <div class="modal-footer">
        <button type="button" class="btn btn-light" data-dismiss="modal" aria-label="OK">${i18n['admin.buttons.ok'] || 'OK'}</button>
      </div>`)
  }

  show () {
    this.$el.modal('show')

    // Background any existing visible modals
    this.$el.prevAll('.modal.in').addClass('background')
  }

  hide () {
    this.$el.modal('hide')
  }
}

// Expose showError as Trestle.Dialog.showError
Dialog.showError = showError

$(document).on('click', '[data-behavior="dialog"]', function (e) {
  e.preventDefault()

  const url = $(this).data('url') || $(this).attr('href')

  const dialog = new Dialog({
    modalClass: $(this).data('dialog-class')
  })

  dialog.load(url)
})
