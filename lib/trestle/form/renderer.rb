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

      delegate :concat, to: :output_buffer

      def initialize(template)
        @template = template
      end

      def render_form(*args, &block)
        capture { instance_exec(*args, &block) }
      end

      def method_missing(name, *args, &block)
        target = @template.form.respond_to?(name) ? @template.form : @template

        if block_given? && !RAW_BLOCK_HELPERS.include?(name)
          result = target.send(name, *args) do |*blockargs|
            render_form(*blockargs, &block)
          end
        else
          result = target.send(name, *args, &block)
        end

        if target == @template.form || WHITELISTED_HELPERS.include?(name)
          concat(result)
        else
          result
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
