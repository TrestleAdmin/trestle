module Trestle
  module Adapters
    extend ActiveSupport::Autoload

    autoload :Adapter

    autoload :ActiveRecordAdapter
    autoload :DraperAdapter
    autoload :SequelAdapter

    # Creates a new Adapter class with the given modules mixed in
    def self.compose(*modules)
      Class.new(Adapter) do
        modules.each { |mod| include(mod) }
      end
    end
  end
end
