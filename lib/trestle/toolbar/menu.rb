module Trestle
  class Toolbar
    class Menu
      delegate :content_tag, :safe_join, to: :@template

      attr_reader :items

      def initialize(template)
        @template = template
        @items = []
      end

      def build(&block)
        builder = Builder.new(self, @template)

        result = @template.capture { @template.instance_exec(builder, &block) }
        items << result if result.present?
      end

      def render_toggle(options={})
        content_tag(:button, type: "button", class: Array(options[:class]) + ["dropdown-toggle"], data: { toggle: "dropdown" }) do
          safe_join([
            content_tag(:span, "", class: "caret"),
            content_tag(:span, I18n.t("trestle.ui.toggle_dropdown", default: "Toggle dropdown"), class: "sr-only")
          ])
        end
      end

      def render_items
        content_tag(:ul, safe_join(items, "\n"), class: "dropdown-menu dropdown-menu-right", role: "menu")
      end

      class Builder
        delegate :admin_link_to, :content_tag, to: :@template

        def initialize(menu, template)
          @menu, @template = menu, template
        end

        def link(content, instance_or_url=nil, options={}, &block)
          options[:class] = Array(options[:class])
          options[:class] << "dropdown-item"

          item { admin_link_to(content, instance_or_url, options, &block) }
        end

        def header(text)
          item(class: "dropdown-header") { text }
        end

        def divider
          item(class: "divider")
        end

        def item(options={}, &block)
          opts = { role: "presentation" }.merge(options)
          item = block_given? ? content_tag(:li, opts, &block) : content_tag(:li, "", opts)

          @menu.items << item

          nil
        end
      end
    end
  end
end
