module Trestle
  class Configuration
    include Configurable

    option :site_title, "Trestle Admin"

    option :menus, []

    def menu(&block)
      menus << Navigation::Block.new(&block)
    end
  end
end
