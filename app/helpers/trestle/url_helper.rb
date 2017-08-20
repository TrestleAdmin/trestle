module Trestle
  module UrlHelper
    def admin_link_to(content, instance=nil, options={}, &block)
      if block_given?
        instance, options = content, instance || {}
        content = capture(&block)
      end

      if admin = (options.key?(:admin) ? Trestle.lookup(options.delete(:admin)) : admin_for(instance))
        link_to(content, admin_url_for(instance, admin: admin), options)
      else
        content
      end
    end

    def admin_url_for(instance, options={})
      admin = options.key?(:admin) ? Trestle.lookup(options[:admin]) : admin_for(instance)
      admin.path(options[:action] || :show, id: admin.to_param(instance)) if admin
    end

    def admin_for(instance)
      Trestle.admins[instance.class.name.underscore.pluralize]
    end
  end
end
