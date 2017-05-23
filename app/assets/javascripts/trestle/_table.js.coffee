$(document).on 'click', '[data-url]', (e) ->
  row = $(e.currentTarget)

  if row.data('url') == 'auto'
    url = row.find('td:not(.actions) a:first').attr('href')
  else
    url = row.data('url')

  Trestle.visit(url) if url

$(document).on 'click', '[data-url] a', (e) ->
  e.stopPropagation()
