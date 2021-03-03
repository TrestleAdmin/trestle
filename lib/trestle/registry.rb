module Trestle
  class Registry
    include Enumerable

    # The admins hash is left exposed for backwards compatibility
    attr_reader :admins

    def initialize
      reset!
    end

    def each(&block)
      @admins.values.each(&block)
    end

    def reset!
      @admins = {}
    end

    def empty?
      none?
    end

    def register(admin)
      @admins[admin.admin_name] = admin
    end

    def lookup(admin)
      return admin if admin.is_a?(Class) && admin < Trestle::Admin
      @admins[admin.to_s]
    end
  end
end
