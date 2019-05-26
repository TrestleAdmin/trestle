module Trestle
  module Controller
    module Callbacks
      extend ActiveSupport::Concern

      included do
        Trestle.config.before_actions.each do |action|
          before_action(action.options, &action.block)
        end

        Trestle.config.after_actions.each do |action|
          after_action(action.options, &action.block)
        end

        Trestle.config.around_actions.each do |action|
          around_action(action.options, &action.block)
        end
      end
    end
  end
end
