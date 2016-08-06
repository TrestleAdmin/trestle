#= require trestle/jquery
#= require trestle/jquery_ujs
#= require trestle/bootstrap
#= require trestle/bootstrap-confirmation
#= require trestle/magnific-popup
#
#= require_self
#= require_tree .

window.Trestle = Trestle = {}

Trestle.ready = (callback) ->
  $(document).on 'ready turbolinks:load', callback
