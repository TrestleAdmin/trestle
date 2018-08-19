module Trestle
  class Configuration
    include Configurable

    ## Customization Options

    # Page title shown in the main admin header and <title> tag
    option :site_title, -> { I18n.t("trestle.title", default: "Trestle") }

    # Custom image in place of the site title for mobile and expanded/desktop navigation
    option :site_logo

    # Custom image for the collapsed/tablet navigation
    option :site_logo_small

    # Text shown in the admin page footer
    option :footer, -> { I18n.t("trestle.footer", default: "Powered by Trestle") }

    # Default timestamp precision
    option :timestamp_precision, :minutes


    ## Mounting Options

    # Path at which to mount the Trestle admin
    option :path, "/admin"

    # Automatically mount the admin within the Rails application's routes
    option :automount, true


    ## Navigation Options

    # Path to consider the application root (for title links and breadcrumbs)
    option :root, -> { Trestle.config.path }

    # Initial breadcrumbs to display in the breadcrumb trail
    option :root_breadcrumbs, -> { [Trestle::Breadcrumb.new(I18n.t("admin.breadcrumbs.home", default: "Home"), Trestle.config.root)] }

    # Default icon class to use when it is not explicitly provided
    option :default_navigation_icon, "fa fa-arrow-circle-o-right"

    # [Internal] List of navigation menu blocks
    option :menus, []

    # Register a global navigation menu block
    def menu(&block)
      menus << Navigation::Block.new(&block)
    end


    ## Extension Options

    # [Internal] List of helper modules to include in all Trestle controllers
    option :helpers, []

    # [Internal] Container module for block-defined helpers
    option :helper_module, Module.new

    # Register global helpers available to all Trestle admins
    def helper(*helpers, &block)
      self.helpers += helpers
      self.helper_module.module_eval(&block) if block_given?
    end

    # Enable or disable Turbolinks within the Trestle admin
    option :turbolinks, defined?(Turbolinks)

    # List of parameters that should persist across requests when paginating or reordering
    option :persistent_params, [:sort, :order, :scope]

    # List of methods to try calling on an instance when displayed by the `display` helper
    option :display_methods, [:display_name, :full_name, :name, :title, :username, :login, :email]

    # Default adapter class used by all admin resources
    option :default_adapter, Adapters.compose(Adapters::ActiveRecordAdapter, Adapters::DraperAdapter)

    # Register a custom form field class
    def form_field(name, klass)
      Form::Builder.register(name, klass)
    end

    # [Internal] List of registered hooks
    option :hooks, Hash.new { |h, k| h[k] = [] }

    # Register an extension hook
    def hook(name, options={}, &block)
      hooks[name.to_s] << Hook.new(name.to_s, options, &block)
    end

    # List of i18n keys to pass into the Trestle.i18n JavaScript object
    option :javascript_i18n_keys, [
      "trestle.confirmation.title", "trestle.confirmation.delete", "trestle.confirmation.cancel", "trestle.dialog.error",
      "admin.buttons.ok", "admin.datepicker.formats.date", "admin.datepicker.formats.datetime", "admin.datepicker.formats.time"
    ]

    # List of load paths for where to find admin definitions
    option :load_paths, [
      -> { ActiveSupport::Dependencies.autoload_paths.grep(/\/app\/admin\Z/) }
    ]

    # When to reload Trestle admin within a to_prepare block (`:always` or `:on_update`)
    option :reload, :on_update


    ## Debugging

    # Enable debugging of form errors
    option :debug_form_errors, Rails.env.development?


    ## Callbacks

    Action = Struct.new(:options, :block)

    # [Internal] List of global before actions
    option :before_actions, []

    # Register a global before action
    def before_action(options={}, &block)
      before_actions << Action.new(options, block)
    end

    # [Internal] List of global after actions
    option :after_actions, []

    # Register a global after action
    def after_action(options={}, &block)
      after_actions << Action.new(options, block)
    end

    # [Internal] List of global around actions
    option :around_actions, []

    # Register a global around action
    def around_action(options={}, &block)
      around_actions << Action.new(options, block)
    end
  end
end
