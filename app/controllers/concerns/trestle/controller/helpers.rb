module Trestle
  module Controller
    module Helpers
      extend ActiveSupport::Concern

      included do
        # Allow inclusion of helpers from Rails application
        self.helpers_path += Rails.application.helpers_paths

        # Add helpers declared from configuration as blocks
        helper Trestle.config.helper_module

        # Add helpers declared from configuration as module references
        helper *Trestle.config.helpers
      end
    end
  end
end
