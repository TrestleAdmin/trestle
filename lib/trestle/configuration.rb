module Trestle
  class Configuration
    include Configurable

    option :site_title, "Trestle Admin"

    option :site_logo
    option :site_logo_small

    option :path, "/admin"
    option :automount, true

    option :default_navigation_icon, "fa fa-arrow-circle-o-right"

    option :menus, []

    def menu(&block)
      menus << Navigation::Block.new(&block)
    end

    option :hooks, Hash.new { |h, k| h[k] = [] }

    def hook(name, &block)
      hooks[name] << block
    end
  end
end
