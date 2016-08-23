module Trestle
  class Admin
    class Builder < Trestle::Builder
      target :admin

      def initialize(name, options={})
        # Create admin subclass
        @admin = Class.new(Admin)

        # Define a constant based on the admin name
        scope = options[:scope] || Object
        scope.const_set("#{name.to_s.camelize}Admin", @admin)

        # Define admin controller class
        # This is done using class_eval rather than Class.new so that the full
        # class name and parent chain is set when Rails' inherited hooks are called.
        @admin.class_eval("class AdminController < Trestle::Admin::Controller; end")

        # Set a reference on the controller class to the admin class
        @controller = @admin.const_get("AdminController")
        @controller.instance_variable_set("@admin", @admin)
      end

      def menu(*args, &block)
        if block_given?
          admin.menu = Navigation::Block.new(admin, &block)
        else
          menu { item(*args) }
        end
      end
    end
  end
end
