module Trestle
  class DebugErrors
    def initialize(errors)
      @errors = errors
    end

    def any?
      @errors.any?
    end

    def each
      if defined?(ActiveModel::Error)
        # Rails 6.1 introduces a unified Error class
        @errors.each do |error|
          yield error.attribute, error.message
        end
      else
        @errors.each do |error, message|
          yield error, message
        end
      end
    end
  end
end
