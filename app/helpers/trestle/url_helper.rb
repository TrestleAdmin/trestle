module Trestle
  module UrlHelper
    def admin_link_to(content, instance=nil, options={}, &block)
      if block_given?
        instance, options = content, instance || {}
        content = capture(&block)
      end

      if options.key?(:admin)
        admin = Trestle.lookup(options.delete(:admin))
      else
        admin = admin_for(instance) || self.admin
      end

      if admin
        link_to(content, admin_url_for(instance, admin: admin), options)
      else
        content
      end
    end

    def admin_url_for(instance, options={})
      admin = Trestle.lookup(options[:admin] || self.admin)
      admin.path(options[:action] || :show, id: admin.to_param(instance)) if admin
    end

    def admin_for(instance)
      Trestle.admins[instance.class.name.underscore.pluralize]
    end
  end
end
