Trestle.ready ->
  $(document).on 'click', '[data-url]', (e) ->
    row = $(e.currentTarget)

    if row.data('url') == 'auto'
      url = row.find('td:not(.actions) a:first').attr('href')
    else
      url = row.data('url')

    document.location = url if url
