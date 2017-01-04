module Trestle
  class Form
    class Renderer
      include ::ActionView::Context
      include ::ActionView::Helpers::CaptureHelper

      # Whitelisted helpers will concatenate their result to the output buffer when called.
      WHITELISTED_HELPERS = [:row, :col, :render, :tab, :toolbar, :table]

      # Raw block helpers will pass their block argument directly to the method
      # without wrapping it in a new output buffer.
      RAW_BLOCK_HELPERS = [:table, :toolbar]

      # The #select method is defined on Kernel. Undefine it so that it can
      # be delegated to the form builder by method_missing.
      undef_method :select

      def initialize(template)
        @template = template
      end

      def render_form(instance, &block)
        with_output_buffer do
          instance_exec(instance, &block)
        end
      end

      def method_missing(name, *args, &block)
        if @template.form.respond_to?(name)
          output_buffer.concat @template.form.send(name, *args, &block)
        else
          if WHITELISTED_HELPERS.include?(name)
            if block_given? && !RAW_BLOCK_HELPERS.include?(name)
              result = @template.send(name, *args) do |*args|
                with_output_buffer { instance_exec(*args, &block) }
              end
            else
              result = @template.send(name, *args, &block)
            end

            output_buffer.concat result
          else
            @template.send(name, *args, &block)
          end
        end
      end

      def respond_to_missing?(name, include_all=false)
        @template.form.respond_to?(name, include_all) ||
          @template.respond_to?(name, include_all) ||
          super
      end
    end
  end
end
