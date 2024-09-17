module Trestle
  class Toolbar
    class Item
      attr_reader :label, :menu

      delegate :admin_link_to, :button_tag, :tag, :safe_join, :icon, to: :@template

      def initialize(template, label, icon: nil, style: nil, **options, &block)
        @template = template
        @label, @options, @block = label, options

        @menu = Menu.new(template)
        @menu.build(&block) if block_given?

        @icon, @style = icon, style
      end

      def ==(other)
        to_s == other.to_s
      end

      def to_s
        if menu.items.any?
          tag.div(class: "btn-group", role: "group") do
            safe_join([render, render_menu], "\n")
          end
        else
          render
        end
      end

      def render
        raise NotImplementedError
      end

      def render_menu
        [
          menu.render_toggle(class: button_style_classes),
          menu.render_items
        ]
      end

      def options
        @options.merge(class: button_classes)
      end

      def button_classes
        classes = (@options[:class] || "").split(/\s/)
        classes.push(*button_style_classes)
        classes.push("has-icon") if @icon
        classes.uniq
      end

      def button_label(content, options)
        icon = icon(@icon) if @icon
        label = tag.span(content, class: "btn-label")

        safe_join([icon, label].compact, " ")
      end

      def button_style
        @style || "default"
      end

      def button_style_classes
        ["btn", "btn-#{button_style}"]
      end
    end

    class Button < Item
      def render
        button_tag(button_label(label, options), options)
      end
    end

    class Link < Item
      attr_reader :instance_or_url

      def initialize(template, label, instance_or_url=nil, **options, &block)
        super(template, label, **options, &block)
        @instance_or_url = instance_or_url
      end

      def render
        admin_link_to(button_label(label, options), instance_or_url, **options)
      end
    end

    class Dropdown < Button
      def options
        super.merge(type: "button", data: { bs_toggle: "dropdown" })
      end

      def label
        safe_join([
          super, tag.span("", class: "caret")
        ], " ")
      end

      def button_style_classes
        super + ["dropdown-toggle"]
      end

      def render_menu
        [menu.render_items]
      end
    end
  end
end
