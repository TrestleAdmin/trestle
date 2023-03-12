module Trestle
  class DebugErrors
    def initialize(errors)
      @errors = errors
    end

    def any?
      @errors.any?
    end

    def each
      @errors.each { |error, message|
        if defined?(ActiveModel::Error)
          # Rails 6.1 introduces a unified Error class
          yield error.attribute, error.message
        else
          yield error, message
        end
      }
    end
  end
end
