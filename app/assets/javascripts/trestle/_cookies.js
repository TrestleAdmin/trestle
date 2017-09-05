Trestle.cookie = {
  get: function(name) {
    name += '=';

    var cookies = document.cookie.split(/;\s*/)

    for (i = cookies.length - 1; i >= 0; i--) {
      if (!cookies[i].indexOf(name)) {
        return cookies[i].replace(name, '');
      }
    }

    return "";
  },

  set: function(name, value) {
    document.cookie = name + "=" + value + "; path=/";
  },

  delete: function(name) {
    document.cookie = name + "=; path=/; expires=Thu, 01 Jan 1970 00:00:00 GMT";
  }
};
