module Trestle
  module UrlHelper
    DIALOG_ACTIONS = [:new, :show, :edit]

    def admin_link_to(content, instance_or_url=nil, options={}, &block)
      if block_given?
        instance_or_url, options = content, instance_or_url || {}
        content = capture(&block)
      end

      if instance_or_url.is_a?(String)
        link_to(content, instance_or_url, options)
      else
        if instance_or_url.is_a?(Hash)
          instance_or_url, options = nil, instance_or_url
        end

        if options.key?(:admin)
          admin = Trestle.lookup(options.delete(:admin))
        elsif instance_or_url.respond_to?(:id)
          admin = admin_for(instance_or_url)
        end

        admin ||= self.admin if respond_to?(:admin)

        if admin
          action = options.delete(:action) || :show

          params = options.delete(:params) || {}
          params[:id] ||= admin.to_param(instance_or_url) if instance_or_url

          if DIALOG_ACTIONS.include?(action) && admin.form.dialog?
            options[:data] ||= {}
            options[:data][:behavior] ||= "dialog"
          end

          link_to(content, admin.path(action, params), options)
        else
          raise ActionController::UrlGenerationError, "An admin could not be inferred. Please specify an admin using the :admin option."
        end
      end
    end

    def admin_url_for(instance, options={})
      admin = Trestle.lookup(options[:admin]) if options.key?(:admin)
      admin ||= admin_for(instance)

      admin.path(options[:action] || :show, id: admin.to_param(instance)) if admin
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
