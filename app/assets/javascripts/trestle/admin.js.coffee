#= require trestle/jquery
#= require trestle/jquery_ujs
#= require trestle/bootstrap
#= require trestle/bootstrap-confirmation
#= require trestle/magnific-popup
#= require trestle/flatpickr
#= require trestle/select2
#
#= require_self
#= require trestle/custom
#= require_tree .

window.Trestle = Trestle = {}

if Turbolinks?.supported
  Trestle.ready = (callback) -> $(document).on 'turbolinks:load', callback
  Trestle.visit = (url) -> Turbolinks.visit(url)
else
  Trestle.ready = (callback) -> $(callback)
  Trestle.visit = (url) -> document.location = url
