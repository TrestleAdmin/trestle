module Trestle
  class Registry
    include Enumerable

    # The admins hash is left exposed for backwards compatibility
    attr_reader :admins

    def initialize
      reset!
    end

    def each(&block)
      @admins.values.sort_by(&:admin_name).each(&block)
    end

    def reset!
      @admins = {}
      @models = nil
    end

    def empty?
      none?
    end

    def register(admin)
      @admins[admin.admin_name] = admin
    end

    def lookup_admin(admin)
      # Given object is already an admin class
      return admin if admin.is_a?(Class) && admin < Trestle::Admin

      # Given object is already an admin instance
      return admin if admin.is_a?(Trestle::Admin)

      @admins[admin.to_s]
    end
    alias lookup lookup_admin

    def lookup_model(model)
      # Lookup each class in the model's ancestor chain
      while model
        admin = models[model.name]
        return admin if admin

        model = model.superclass
      end

      # No admin found
      nil
    end

  private
    def models
      @models ||= @admins.values.inject({}) { |result, admin|
        if admin.respond_to?(:register_model?) && admin.register_model?
          result[admin.model.name] ||= admin
        end

        result
      }
    end
  end
end
