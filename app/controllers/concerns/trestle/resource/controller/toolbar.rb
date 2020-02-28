module Trestle
  class Resource
    class Controller
      module Toolbar
        def default_toolbar_builder
          Resource::Toolbar::Builder
        end
      end
    end
  end
end
