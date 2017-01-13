module Trestle
  class Form
    class Field
      attr_reader :builder, :template, :name, :options, :block

      delegate :admin, :content_tag, :concat, :safe_join, :icon, to: :template

      def initialize(builder, template, name, options={}, &block)
        @builder, @template, @name, @options, @block = builder, template, name, options, block

        @options[:readonly] = @options.fetch(:readonly) { admin.readonly? }
      end

      def errors
        builder.object.errors[name]
      end

      def form_group(opts={})
        @builder.form_group(name, options.merge(opts)) do
          yield
        end
      end

      def render
        form_group do
          field
        end
      end

      def field
        raise NotImplementedError
      end
    end
  end
end
