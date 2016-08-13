module Trestle
  class Configuration
    include Configurable

    option :site_title, "Trestle Admin"

    option :path, "/admin"
    option :automount, true

    option :default_navigation_icon, "fa fa-arrow-circle-o-right"

    option :menus, []

    def menu(&block)
      menus << Navigation::Block.new(&block)
    end
  end
end
