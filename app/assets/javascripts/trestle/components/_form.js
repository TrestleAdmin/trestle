// Prevent enter key from submitting the form
$(document).on('keypress', '.app-main form :input:not(textarea):not([type=submit])', function(e) {
  if (e.keyCode == 13) {
    e.preventDefault();
  }
});

Trestle.init(function(e, root) {
  $('form[data-behavior="trestle-form"]', root)
    .on('ajax:complete', function(e, xhr, status) {
      // Find the parent context and replace content
      var context = $(this).closest('[data-context]');
      context.html(xhr.responseText);

      // Initialize replaced elements within the context
      $(Trestle).trigger('init', context);

      // Focus the correct tab
      Trestle.focusActiveTab();
    })
    .on('ajax:success', function(e, data, status, xhr) {
      var location = xhr.getResponseHeader("X-Trestle-Location");

      if (location) {
        // Update the URL in the browser and context
        history.replaceState({}, "", location);

        // Update the URL of the context
        var context = $(this).closest('[data-context]');
        context.data('context', location);
      }
    });

  // Loading indicator
  $('form[data-behavior="trestle-form"] :submit', root).click(function() {
    var button = $(this);

    // Delay to ensure form is still submitted
    setTimeout(function() {
      button.prop('disabled', true).addClass('loading');
    }, 1);
  });
});
