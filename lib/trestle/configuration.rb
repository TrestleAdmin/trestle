module Trestle
  class Configuration
    include Configurable

    option :site_title, -> { I18n.t("trestle.title", default: "Trestle") }
    option :footer, -> { I18n.t("trestle.footer", default: "Powered by Trestle") }

    option :site_logo
    option :site_logo_small

    option :path, "/admin"
    option :automount, true

    option :turbolinks, defined?(Turbolinks)

    option :display_methods, [:display_name, :full_name, :name, :title, :username, :login, :email, :to_s]

    option :persistent_params, [:sort, :order, :scope]

    option :default_adapter, Adapters::Adapter.compose(Adapters::ActiveRecordAdapter, Adapters::DraperAdapter)

    option :root_breadcrumbs, -> { [Trestle::Breadcrumb.new(I18n.t("admin.breadcrumbs.home", default: "Home"), Trestle.config.path)] }

    option :default_navigation_icon, "fa fa-arrow-circle-o-right"

    option :javascript_i18n_keys, ["admin.confirmation.title", "admin.confirmation.delete", "admin.confirmation.cancel"]

    option :menus, []

    def menu(&block)
      menus << Navigation::Block.new(&block)
    end

    option :hooks, Hash.new { |h, k| h[k] = [] }

    def hook(name, &block)
      hooks[name.to_s] << block
    end

    option :helpers, []
    option :helper_module, Module.new

    def helper(*helpers, &block)
      self.helpers += helpers
      self.helper_module.module_eval(&block) if block_given?
    end

    def form_field(name, klass)
      Form::Builder.register(name, klass)
    end

    Action = Struct.new(:options, :block)

    option :before_actions, []

    def before_action(options={}, &block)
      before_actions << Action.new(options, block)
    end

    option :after_actions, []

    def after_action(options={}, &block)
      after_actions << Action.new(options, block)
    end

    option :around_actions, []

    def around_action(options={}, &block)
      around_actions << Action.new(options, block)
    end
  end
end
