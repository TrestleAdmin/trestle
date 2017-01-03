module Trestle
  class Form
    class Renderer
      include ::ActionView::Context
      include ::ActionView::Helpers::CaptureHelper

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

      def render(*args)
        output_buffer.concat @template.render(*args)
      end

      def toolbar(name, &block)
        with_output_buffer do
          @template.content_for(:"#{name}_toolbar", @template.instance_eval(&block))
        end
      end

      def table(*args, &block)
        output_buffer.concat @template.table(*args, &block)
      end

      def icon(*args)
        @template.icon(*args)
      end

      def method_missing(name, *args, &block)
        target = @template.form.respond_to?(name) ? @template.form : @template

        if block_given?
          result = target.send(name, *args) do |*args|
            with_output_buffer { instance_exec(*args, &block) }
          end
        else
          result = target.send(name, *args)
        end

        output_buffer.concat(result)
      end

      def respond_to_missing?(name, include_all=false)
        @template.form.respond_to?(name, include_all) ||
          @template.respond_to?(name, include_all) ||
          super
      end
    end
  end
end
