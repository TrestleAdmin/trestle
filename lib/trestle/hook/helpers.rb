module Trestle
  class Hook
    module Helpers
      # Evaluates any defined hooks with the given name and returns the result.
      #
      # Each hook is evaluated and passed any provided arguments, and the result
      # is concatenated together. If no hooks are defined, and a block is passed
      # to this helper, then the block will be evaluated instead.
      #
      # name  - Name of hook to evaluate
      # args  - Arguments to pass to hook blocks
      # block - Optional block to evaluate as a fallback if no hooks are defined
      #
      # Examples
      #
      #   <%= hook("index.toolbar.primary", toolbar) %>
      #
      #   <%= hook("view.title") do %>
      #     Default Title
      #   <% end %>
      #
      # Returns a HTML-safe string.
      def hook(name, *args, &block)
        hooks = hooks(name)

        if hooks.any?
          safe_join(hooks.map { |hook|
            hook.evaluate(self, *args)
          }, "\n")
        elsif block_given?
          capture(*args, &block)
        end
      end

      # Returns true or false depending on whether there are any defined hooks
      # (either on the current admin or globally) with the given name.
      def hook?(name)
        hooks(name).any?
      end

    protected
      def hooks(name)
        hook_sets.map { |set| set.for(name) }.inject(&:+).select { |h| h.visible?(self) }
      end

      def hook_sets
        @_hook_sets ||= [
          (admin.hooks if defined?(admin) && admin.respond_to?(:hooks)),
          Trestle.config.hooks
        ].compact
      end
    end
  end
end
