export function getCookie (name) {
  name += '='

  var cookies = document.cookie.split(/;\s*/)

  for (let i = cookies.length - 1; i >= 0; i--) {
    if (!cookies[i].indexOf(name)) {
      var value = cookies[i].replace(name, '')
      return decodeURIComponent(value)
    }
  }

  return ''
}

export function setCookie (name, value) {
  document.cookie = `${name}=${encodeURIComponent(value)}; path=/`
}

export function deleteCookie (name) {
  document.cookie = `${name}=; path=/; expires=Thu, 01 Jan 1970 00:00:00 GMT`
}

export default {
  get: getCookie,
  set: setCookie,
  delete: deleteCookie
}
