module Trestle
  module HookHelper
    def hook(name, *args)
      hooks = hooks(name)

      if hooks.any?
        safe_join(hooks.map { |hook|
          hook.evaluate(self, *args)
        }, "\n")
      elsif block_given?
        capture(*args, &Proc.new)
      end
    end

    def hook?(name)
      hooks(name).any?
    end

  protected
    def hooks(name)
      hook_sets.map { |set| set.for(name) }.inject(&:+).select { |h| h.visible?(self) }
    end

    def hook_sets
      @_hook_sets ||= [
        (admin.hooks if defined?(admin) && admin),
        Trestle.config.hooks
      ].compact
    end
  end
end
