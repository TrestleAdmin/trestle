module Trestle
  module HookHelper
    def hook(name)
      safe_join(hooks(name).map { |hook|
        hook.evaluate(self)
      }, "\n")
    end

    def hook?(name)
      Trestle.config.hooks.key?(name.to_s) && hooks(name).any?
    end

  protected
    def hooks(name)
      Trestle.config.hooks[name.to_s].select { |h| h.visible?(self) }
    end
  end
end
