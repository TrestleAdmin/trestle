module Trestle
  class Form
    class Renderer
      include ::ActionView::Context
      include ::ActionView::Helpers::CaptureHelper

      # Whitelisted helpers will concatenate their result to the output buffer when called.
      WHITELISTED_HELPERS = [:row, :col, :render, :tab, :table, :divider, :h1, :h2, :h3, :h4, :h5, :h6, :panel, :well]

      # Raw block helpers will pass their block argument directly to the method
      # without wrapping it in a new output buffer.
      RAW_BLOCK_HELPERS = [:table, :toolbar]

      # The #select and #display methods are defined on Kernel. Undefine them so
      # that they can be delegated to the form builder or template by method_missing.
      undef_method :select, :display

      delegate :concat, to: :output_buffer

      def initialize(template, form=nil)
        @template = template
        @form = form || @template.form
      end

      def render_form(*args, &block)
        capture { instance_exec(*args, &block).to_s }
      end

      def fields_for(*args, &block)
        result = @form.fields_for(*args) do |f|
          renderer = self.class.new(@template, f)
          renderer.render_form(f, &block)
        end

        concat(result)
      end

      def method_missing(name, *args, &block)
        target = @form.respond_to?(name) ? @form : @template

        if block_given? && !RAW_BLOCK_HELPERS.include?(name)
          result = target.send(name, *args) do |*blockargs|
            render_form(*blockargs, &block)
          end
        else
          result = target.send(name, *args, &block)
        end

        if target == @form || WHITELISTED_HELPERS.include?(name)
          concat(result)
        else
          result
        end
      end

      def respond_to_missing?(name, include_all=false)
        @form.respond_to?(name, include_all) ||
          @template.respond_to?(name, include_all) ||
          super
      end
    end
  end
end
