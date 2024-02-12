import ErrorModal from './error_modal'

document.addEventListener('turbo:frame-missing', async (e) => {
  e.preventDefault()

  const response = e.detail.response
  const title = `${response.status} (${response.statusText})`
  response.text().then(content => ErrorModal.show({ title, content }))
})
