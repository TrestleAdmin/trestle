$(document).on 'click', 'tr[data-url]', (e) ->
  row = $(e.currentTarget)

  if row.data('url') == 'auto'
    url = row.find('td:not(.actions) a:first').attr('href')
  else
    url = row.data('url')

  if url
    if e.metaKey or e.ctrlKey
      window.open(url, '_blank')
    else
      Trestle.visit(url)

$(document).on 'click', 'tr[data-url] a', (e) ->
  e.stopPropagation()
