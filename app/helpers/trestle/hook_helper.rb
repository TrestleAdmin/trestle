module Trestle
  module HookHelper
    def hook(name)
      safe_join(hooks[name.to_s].map { |hook|
        instance_exec(&hook)
      }, "\n") if hook?(name)
    end

    def hook?(name)
      hooks.key?(name.to_s) && hooks[name.to_s].any?
    end

  protected
    def hooks
      Trestle.config.hooks
    end
  end
end
