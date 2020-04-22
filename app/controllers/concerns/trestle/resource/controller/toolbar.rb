module Trestle
  class Resource
    module Controller
      module Toolbar
        def default_toolbar_builder
          Resource::Toolbar::Builder
        end
      end
    end
  end
end
