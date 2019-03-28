module Trestle
  class Toolbar
    class Builder
      def initialize(template)
        @template = template
      end

      def button(label, options={}, &block)
        Button.new(@template, label, options, &block)
      end

      def link(label, instance_or_url={}, options={}, &block)
        Link.new(@template, label, instance_or_url, options, &block)
      end

      def dropdown(label=nil, options={}, &block)
        Dropdown.new(@template, label, options, &block)
      end

      # Only methods explicitly tagged as builder methods will be automatically
      # appended to the toolbar when called by Toolbar::Context.

      class_attribute :builder_methods
      self.builder_methods = []

      def self.builder_method(*methods)
        self.builder_methods += methods
      end

      builder_method :button, :link, :dropdown
    end
  end
end
