module Trestle
  class Toolbar
    def initialize(builder=Builder)
      @builder = builder
      @blocks = []
    end

    def groups(template, *args)
      Enumerator.new do |y|
        @blocks.each do |block|
          builder = @builder.new(template, *args)
          block.evaluate(builder, template, y, *args)
        end
      end
    end

    def append(&block)
      @blocks.push(Block.new(&block))
    end

    def prepend(&block)
      @blocks.unshift(Block.new(&block))
    end

    # Wraps a toolbar block to provide evaluation within the context of a template and enumerator
    class Block
      def initialize(&block)
        @block = block
      end

      def evaluate(builder, template, enumerator, *args)
        context = Context.new(builder, enumerator, *args)
        result = template.capture(context, *args, &@block)
        enumerator << [result] if result.present?
      end
    end

    # The toolbar Context is the object that is yielded to a toolbar block and handles the delegation of builder methods.
    class Context
      attr_reader :builder

      def initialize(builder, enumerator, *args)
        @builder, @enumerator = builder, enumerator
        @args = args
      end

      def group
        if @current_group
          yield
        else
          @current_group = []
          yield
          @enumerator << @current_group
          @current_group = nil
        end
      end

    private
      def respond_to_missing?(name, include_all=false)
        builder.respond_to?(name) || super
      end

      def method_missing(name, *args, &block)
        group do
          @current_group << builder.send(name, *args, &block)
        end
      end
    end

    class Builder
      def initialize(template)
        @template = template
      end

      def button(content, options={})
        options[:class] = button_classes_from_options(options)

        button_tag(button_label(content, options), options)
      end

      def link(content, instance_or_url={}, options={})
        options = instance_or_url if instance_or_url.is_a?(Hash)
        options[:class] = button_classes_from_options(options)

        admin_link_to(button_label(content, options), instance_or_url, options)
      end

    private
      delegate :admin_link_to, :button_tag, :content_tag, :safe_join, :icon, to: :@template

      def button_classes_from_options(options)
        classes = (options[:class] || "").split("\s")
        classes.unshift("btn-#{options.delete(:style) || "default"}")
        classes.unshift("btn") unless classes.include?("btn")
        classes
      end

      def button_label(content, options)
        icon = icon(options.delete(:icon)) if options[:icon]
        label = content_tag(:span, content, class: "btn-label")

        safe_join([icon, label].compact, " ")
      end
    end
  end
end
