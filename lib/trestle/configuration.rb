module Trestle
  class Configuration
    include Configurable

    option :site_title, "Trestle Admin"
    option :footer, "Powered by Trestle"

    option :site_logo
    option :site_logo_small

    option :path, "/admin"
    option :automount, true

    option :turbolinks, defined?(Turbolinks)

    option :persistent_params, [:sort, :order, :scope]

    option :default_adapter, Adapters::Adapter.compose(Adapters::ActiveRecordAdapter, Adapters::DraperAdapter)

    option :root_breadcrumb, -> { Trestle::Breadcrumb.new("Home", Trestle.config.path) }

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
