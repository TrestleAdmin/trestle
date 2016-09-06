module Trestle
  module HookHelper
    def hook(name)
      safe_join(Trestle.config.hooks[name.to_s].map { |hook|
        instance_exec(&hook)
      }, "\n")
    end

    def hook?(name)
      Trestle.config.hooks[name.to_s].any?
    end
  end
end
