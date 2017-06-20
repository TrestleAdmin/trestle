Trestle.ready ->
  $('[data-behavior~="zoom"]').magnificPopup
    type: 'image'
    closeOnContentClick: false
    closeBtnInside: false
    mainClass: 'mfp-with-zoom mfp-img-mobile'
    zoom:
      enabled: true
      duration: 150

  $('[data-behavior~="gallery"]').magnificPopup
    delegate: 'a'
    type: 'image'
    closeOnContentClick: false
    closeBtnInside: false
    mainClass: 'mfp-with-zoom mfp-img-mobile'
    gallery:
      enabled: true
    zoom:
      enabled: true
      duration: 150
