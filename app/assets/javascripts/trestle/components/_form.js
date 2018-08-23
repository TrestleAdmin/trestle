// Prevent enter key from submitting the form
$(document).on('keypress', 'form[data-behavior="trestle-form"] :input:not(textarea):not([type=submit])', function(e) {
  if (e.keyCode == 13) {
    e.preventDefault();
  }
});

Trestle.init(function(e, root) {
  var form = $(root).find('form[data-behavior="trestle-form"]');

  form
    .on('ajax:send', function(e, xhr) {
      // Disable submit buttons
      $(this).find(':submit').prop('disabled', true);

      // Set loading status on button that triggered submission
      var button = $(this).data('trestle:submitButton');
      if (button) { $(button).addClass('loading'); }
    })
    .on('ajax:complete', function(e, xhr, status) {
      // Reset submit buttons
      $(this).find(':submit').prop('disabled', false).removeClass('loading');
      $(this).removeData('trestle:submitButton');

      var contentType = xhr.getResponseHeader("Content-Type");

      if (contentType && contentType.split(";")[0] == "text/html") {
        if (/<html/i.test(xhr.responseText)) {
          // Response is a full HTML page, likely an error page. Render within an iframe.
          var context = $(this).closest('[data-context]');
          var iframe = $("<iframe>").addClass('error-iframe').get(0);
          context.html(iframe);

          iframe.contentWindow.document.documentElement.innerHTML = xhr.responseText;
        } else {
          // Find the parent context and replace content
          var context = $(this).closest('[data-context]');
          context.html(xhr.responseText);

          // Initialize replaced elements within the context
          $(Trestle).trigger('init', context);

          // Focus the correct tab
          Trestle.focusActiveTab();
        }
      } else {
        // Assume an error response
        var title = xhr.status + " (" + xhr.statusText + ")";
        Trestle.Dialog.showError(title, xhr.responseText);
      }
    })
    .on('ajax:success', function(e, data, status, xhr) {
      var context = $(this).closest('[data-context]');
      var location = xhr.getResponseHeader("X-Trestle-Location");

      if (location) {
        // Retain current active tab
        location = location + document.location.hash;

        // Update the URL in the browser and context
        history.replaceState({}, "", location);
        context.data('context', location);
      }

      // Refresh the main context
      if (!context.hasClass('app-main')) {
        Trestle.refreshMainContext();
      }
    });

  form.find(':submit').click(function() {
    // Save this as the button that triggered the form
    $(this).closest('form').data('trestle:submitButton', this);
  });
});
