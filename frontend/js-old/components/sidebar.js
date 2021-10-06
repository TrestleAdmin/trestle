import $ from 'jquery'

import { ready } from '../core/events'
import cookie from '../core/cookie'

import Navigation from './navigation'

ready(function () {
  const $body = $('body')
  const $wrapper = $('.app-wrapper')
  const $sidebar = $('.app-sidebar')

  // Toggle mobile navigation using menu button

  $sidebar.find('.navbar-toggler').on('click', function (e) {
    e.preventDefault()

    $wrapper.addClass('animate')
    $body.toggleClass('mobile-nav-expanded')
  })

  $wrapper.on('transitionend webkitTransitionEnd', function () {
    $(this).removeClass('animate')
  })

  // Interacting outside of the sidebar closes the navigation

  $wrapper.on('click touchstart', function (e) {
    const navExpanded = $('body').hasClass('mobile-nav-expanded')

    const clickInHeader = $(e.target).closest('.app-header').length
    const clickInSidebar = $(e.target).closest('.app-sidebar').length

    if (navExpanded && !clickInHeader && !clickInSidebar) {
      e.stopPropagation()
      e.preventDefault()

      $wrapper.addClass('animate')
      $body.removeClass('mobile-nav-expanded')
    }
  })

  // Toggle sidebar expand/collapse

  $sidebar.find('.toggle-sidebar').on('click', function (e) {
    e.preventDefault()

    if ($body.hasClass('sidebar-expanded') || $body.hasClass('sidebar-collapsed')) {
      $body.removeClass('sidebar-expanded').removeClass('sidebar-collapsed')
      cookie.delete('trestle:sidebar')
    } else if ($(document).width() >= 1200) {
      $body.addClass('sidebar-collapsed')
      cookie.set('trestle:sidebar', 'collapsed')
    } else if ($(document).width() >= 768) {
      $body.addClass('sidebar-expanded')
      cookie.set('trestle:sidebar', 'expanded')
    }
  })

  // Toggle navigation groups

  $sidebar.find('.nav-header a').on('click', function (e) {
    e.preventDefault()

    const list = $(this).closest('ul')
    Navigation.toggle(list)
  })

  // Scroll sidebar to active item

  const $active = $sidebar.find('.active')
  if ($active.length) {
    $sidebar.find('.app-sidebar-inner').scrollTop($active.offset().top - 100)
  }
})
