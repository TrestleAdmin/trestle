module Trestle
  module UrlHelper
    MODAL_ACTIONS = [:new, :show, :edit]

    def admin_link_to(content, instance_or_url=nil, options={}, &block)
      # Block given - ignore content parameter and capture content from block
      if block_given?
        instance_or_url, options = content, instance_or_url || {}
        content = capture(&block)
      end

      if instance_or_url.is_a?(String)
        # Treat string URL as regular link
        link_to(content, instance_or_url, options)
      else
        # Normalize options if instance is not provided
        if instance_or_url.is_a?(Hash)
          instance, options = nil, instance_or_url
        else
          instance = instance_or_url
        end

        # Determine admin
        if options.key?(:admin)
          admin = Trestle.lookup(options.delete(:admin))
        elsif instance
          admin = admin_for(instance)
        end

        admin ||= self.admin if respond_to?(:admin)

        if admin
          # Ensure admin has controller context
          admin = admin.new(self) if admin.is_a?(Class)

          # Generate path
          action = options.delete(:action) || :show
          params = options.delete(:params) || {}

          if admin.respond_to?(:instance_path) && instance
            path = admin.instance_path(instance, params.reverse_merge(action: action))
          else
            params[:id] ||= admin.to_param(instance) if instance
            path = admin.path(action, params)
          end

          # Determine link data options
          options[:data] ||= {}

          if MODAL_ACTIONS.include?(action) && admin.respond_to?(:form) && admin.form.modal?
            options[:data][:controller] ||= "modal-trigger"
          else
            options[:data][:turbo_frame] ||= (modal_request? ? "modal" : "_top")
          end

          link_to(content, path, options)
        else
          raise ActionController::UrlGenerationError, "An admin could not be inferred. Please specify an admin using the :admin option."
        end
      end
    end

    def admin_url_for(instance, admin: nil, **options)
      admin = Trestle.lookup(admin) if admin
      admin ||= admin_for(instance)
      return unless admin

      # Ensure admin has controller context
      admin = admin.new(self) if admin.is_a?(Class)

      if admin.respond_to?(:instance_path)
        admin.instance_path(instance, options)
      else
        admin.path(options[:action] || :show, id: admin.to_param(instance))
      end
    end

    def admin_for(instance)
      Trestle.lookup_model(instance.class)
    end
  end
end
