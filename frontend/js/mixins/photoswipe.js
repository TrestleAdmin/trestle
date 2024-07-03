const usePhotoSwipe = (controller) => {
  Object.assign(controller, {
    loadPhotoSwipe () {
      return import(/* webpackChunkName: "photoswipe" */ 'photoswipe')
        .then(module => module.default)
    }
  })
}

export default usePhotoSwipe
