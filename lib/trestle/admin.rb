module Trestle
  class Admin
    extend ActiveSupport::Autoload

    autoload :Builder
    autoload :Controller

    delegate :to_param, to: :class

    def initialize(context=nil)
      @context = context
    end

    # Delegate all missing methods to corresponding class method if available
    def method_missing(name, *args, &block)
      if self.class.respond_to?(name)
        self.class.send(name, *args, &block)
      else
        super
      end
    end

    def respond_to_missing?(name, include_private=false)
      self.class.respond_to?(name, include_private) || super
    end

    class << self
      attr_accessor :menu

      attr_accessor :form

      attr_accessor :additional_routes

      attr_writer :options
      attr_writer :breadcrumb

      def options
        @options ||= {}
      end

      def tables
        @tables ||= {}
      end

      # Deprecated: Use `tables[:index]` instead
      def table
        tables[:index]
      end

      # Deprecated: Use `tables[:index]=` instead
      def table=(table)
        tables[:index] = table
      end

      def breadcrumbs
        Breadcrumb::Trail.new(Array(Trestle.config.root_breadcrumbs) + [breadcrumb])
      end

      def breadcrumb
        if @breadcrumb
          Breadcrumb.cast(@breadcrumb.call)
        else
          default_breadcrumb
        end
      end

      def default_breadcrumb
        Breadcrumb.new(human_admin_name, path)
      end

      def admin_name
        name.underscore.sub(/_admin$/, '')
      end

      def i18n_key
        admin_name
      end

      def human_admin_name
        I18n.t("admin.breadcrumbs.#{i18n_key}", default: name.demodulize.underscore.sub(/_admin$/, '').titleize)
      end

      def translate(key, options={})
        defaults = [:"admin.#{i18n_key}.#{key}", :"admin.#{key}"]
        defaults << options[:default] if options[:default]

        I18n.t(defaults.shift, options.merge(default: defaults))
      end
      alias t translate

      def parameter_name
        admin_name.singularize
      end

      def route_name
        "#{admin_name.tr('/', '_')}_admin"
      end

      def controller_path
        "admin/#{name.underscore.sub(/_admin$/, '')}"
      end

      def controller_namespace
        "#{name.underscore}/admin"
      end

      def path(action=root_action, options={})
        Engine.routes.url_for(options.merge(controller: controller_namespace, action: action, only_path: true))
      end

      def to_param(*)
        raise NoMethodError, "#to_param called on non-resourceful admin. You may need to explicitly specify the admin."
      end

      def actions
        [:index]
      end

      def root_action
        :index
      end

      def routes
        admin = self

        Proc.new do
          scope controller: admin.controller_namespace, path: admin.options[:path] || admin.admin_name do
            get "", action: "index", as: admin.route_name

            instance_exec(&admin.additional_routes) if admin.additional_routes
          end
        end
      end

      def railtie_routes_url_helpers(include_path_helpers=true)
        Trestle.railtie_routes_url_helpers(include_path_helpers)
      end

      def build(&block)
        Admin::Builder.build(self, &block)
      end

      def validate!
        # No validations by default. This can be overridden in subclasses.
      end
    end
  end
end
