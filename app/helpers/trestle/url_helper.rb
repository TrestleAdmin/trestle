module Trestle
  module UrlHelper
    def admin_link_to(content, instance=nil, options={}, &block)
      if block_given?
        instance, options = content, instance || {}
        content = capture(&block)
      end

      if instance.is_a?(Hash)
        instance, options = nil, instance
      end

      if options.key?(:admin)
        admin = Trestle.lookup(options.delete(:admin))
      elsif instance
        admin = admin_for(instance) || self.admin
      else
        admin = self.admin
      end

      if admin
        action = options.delete(:action) || :show

        params = options.delete(:params) || {}
        params[:id] ||= admin.to_param(instance) if instance

        if admin.form.dialog?
          options[:data] ||= {}
          options[:data][:behavior] ||= "dialog"
        end

        link_to(content, admin.path(action, params), options)
      else
        raise ActionController::UrlGenerationError, "An admin could not be inferred. Please specify an admin using the :admin option."
      end
    end

    def admin_url_for(instance, options={})
      admin = Trestle.lookup(options[:admin]) if options.key?(:admin)
      admin ||= admin_for(instance)

      admin.path(options[:action] || :show, id: admin.to_param(instance)) if admin
    end

    def admin_for(instance)
      Trestle.admins[instance.class.name.underscore.pluralize]
    end
  end
end
