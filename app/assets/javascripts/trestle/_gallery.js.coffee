Trestle.ready ->
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
