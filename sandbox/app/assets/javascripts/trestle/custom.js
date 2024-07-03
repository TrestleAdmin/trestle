// This file may be used for providing additional customizations to the Trestle
// admin. It will be automatically included within all admin pages.
//
// For organizational purposes, you may wish to define your customizations
// within individual partials and `require` them here.
//
//  e.g. //= require "trestle/custom/my_custom_js"

//= require "trestle/custom/controllers/modal_demo/trigger_controller"
//= require "trestle/custom/controllers/modal_demo/modal_controller"
//= require "trestle/custom/controllers/theme_controller"

Stimulus.register('modal-demo--trigger', ModalDemo.TriggerController)
Stimulus.register('modal-demo--modal', ModalDemo.ModalController)
Stimulus.register('theme', ThemeController)

Trestle.ready(function () {
  console.log('Trestle.ready')
})

Trestle.init(function (root) {
  console.log('Trestle.init', root)
})
