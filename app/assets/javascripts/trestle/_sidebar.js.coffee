$(document).on 'ready turbolinks:load', ->
  # Toggle navigation using menu button

  $('.app-sidebar .navbar-toggle').on 'click touchstart', (e) ->
    e.preventDefault()

    $('.app-wrapper').addClass('animate')
    $('body').toggleClass('mobile-nav-expanded')

  $('.app-wrapper').on 'transitionend webkitTransitionEnd', ->
    $(this).removeClass('animate')


  # Interacting outside of the sidebar closes the navigation

  $('.app-sidebar').on 'click touchstart', (e) ->
    e.stopPropagation()

  $('.app-wrapper').on 'click touchstart', ->
    if $('body').hasClass('mobile-nav-expanded')
      $('.app-wrapper').addClass('animate')
      $('body').removeClass('mobile-nav-expanded')
