module Trestle
  class Table
    class Row
      attr_reader :table, :options, :block

      def initialize(table, options={}, &block)
        @table, @options = table, options
        @block = block if block_given?
      end

      def renderer(template)
        Renderer.new(self, template)
      end

      class Renderer
        delegate :table, to: :@row

        def initialize(row, template)
          @row, @template = row, template
        end

        def options(instance)
          options = Trestle::Options.new
          options.merge!(data: { url: admin_url_for(instance) }) if table.options[:admin]
          options.merge!(@row.options)
          options.merge!(@template.instance_exec(instance, &@row.block)) if @row.block
          options
        end

      protected
        def admin_url_for(instance)
          @template.admin_url_for(instance, admin: table.options[:admin])
        end
      end
    end
  end
end
