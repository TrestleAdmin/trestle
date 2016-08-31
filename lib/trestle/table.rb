module Trestle
  class Table
    extend ActiveSupport::Autoload

    autoload :Builder
    autoload :Column
    autoload :ActionsColumn

    attr_reader :columns, :options

    def initialize(options={})
      @options = options
      @columns = []
    end

    def classes
      options[:class] || "trestle-table"
    end

    def data
      options[:data]
    end
  end
end
