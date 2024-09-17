module Trestle
  class Toolbar
    class Menu
      delegate :tag, :safe_join, to: :@template

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
        tag.button(type: "button", class: Array(options[:class]) + ["dropdown-toggle dropdown-toggle-split"], data: { bs_toggle: "dropdown" }, aria: { expanded: false }) do
          tag.span(I18n.t("trestle.ui.toggle_dropdown", default: "Toggle dropdown"), class: "visually-hidden")
        end
      end

      def render_items
        tag.ul(safe_join(items, "\n"), class: "dropdown-menu dropdown-menu-end", role: "menu")
      end

      class Builder
        delegate :admin_link_to, :tag, to: :@template

        def initialize(menu, template)
          @menu, @template = menu, template
        end

        def link(content, instance_or_url=nil, options={}, &block)
          if instance_or_url.is_a?(Hash)
            instance_or_url, options = nil, instance_or_url
          end

          options[:class] = Array(options[:class])
          options[:class] << "dropdown-item"

          item { admin_link_to(content, instance_or_url, **options, &block) }
        end

        def header(text)
          item { tag.h6(text, class: "dropdown-header") }
        end

        def divider
          item { tag.hr(class: "dropdown-divider") }
        end

        def item(options={}, &block)
          item = block_given? ? tag.li(**options, &block) : tag.li("", **options)

          @menu.items << item

          nil
        end
      end
    end
  end
end
