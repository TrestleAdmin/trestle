module Trestle
  class Table
    extend ActiveSupport::Autoload

    autoload :Automatic
    autoload :Builder
    autoload :Column
    autoload :ActionsColumn
    autoload :SelectColumn

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

    def sortable?
      options[:sortable] == true
    end
  end
end
