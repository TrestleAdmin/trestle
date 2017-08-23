// Polyfill for $.load which was removed in jQuery 3.0 but is used for Bootstrap modals
jQuery.fn.load = function(callback) { $(this).on("load", callback) };
