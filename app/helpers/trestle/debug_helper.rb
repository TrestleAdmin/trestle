module Trestle
  module DebugHelper
    def debug_form_errors?
      Trestle.config.debug_form_errors && instance_has_errors?
    end

    def instance_has_errors?
      instance.errors.any? rescue false
    end
  end
end
