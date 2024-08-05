Trestle.admin(:miscellaneous, scope: Components) do
  menu do
    group :components do
      item :miscellaneous, icon: "fas fa-box-open", priority: 7
    end
  end

  controller do
    def modal
      render turbo_stream: turbo_stream.modal
    end

    def modal_post
      render turbo_stream: turbo_stream.modal
    end
  end

  routes do
    get "modal"
    post "modal_post"
  end
end
