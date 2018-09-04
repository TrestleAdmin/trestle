module Trestle
  module UrlHelper
    DIALOG_ACTIONS = [:new, :show, :edit]

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
          if DIALOG_ACTIONS.include?(action) && admin.form.dialog?
            options[:data] ||= {}
            options[:data][:behavior] ||= "dialog"
          end

          link_to(content, path, options)
        else
          raise ActionController::UrlGenerationError, "An admin could not be inferred. Please specify an admin using the :admin option."
        end
      end
    end

    def admin_url_for(instance, options={})
      admin = Trestle.lookup(options.delete(:admin)) if options.key?(:admin)
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
      klass = instance.class

      while klass
        admin = Trestle.admins[klass.name.underscore.pluralize]
        return admin if admin

        klass = klass.superclass
      end

      # No admin found
      nil
    end
  end
end
