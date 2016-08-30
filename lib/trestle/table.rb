module Trestle
  class Table
    attr_reader :columns, :options

    def initialize(options={})
      @options = options
      @columns = []
    end

    def classes
      options[:class] || "trestle-table"
    end
  end
end
