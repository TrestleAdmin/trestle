module Trestle
  class Table
    class Row
      attr_reader :options, :block

      def initialize(options={}, &block)
        @options = options
        @block = block if block_given?
      end

      def renderer(template)
        Renderer.new(self, template)
      end

      class Renderer
        def initialize(row, template)
          @row, @template = row, template
        end

        def options(instance)
          options = Trestle::Options.new(data: { url: @template.admin_url_for(instance) })
          options.merge!(@row.options)
          options.merge!(@template.instance_exec(instance, &@row.block)) if @row.block
          options
        end
      end
    end
  end
end
