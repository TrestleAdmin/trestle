module Trestle
  module HookHelper
    def hook(name)
      if hook?(name)
        safe_join(hooks(name).map { |hook|
          hook.evaluate(self)
        }, "\n")
      elsif block_given?
        capture(&Proc.new)
      end
    end

    def hook?(name)
      hook_sets.any? { |set| set.any?(name) }
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
