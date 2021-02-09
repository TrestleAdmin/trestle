module Trestle
  # This module facilitiates the delegation of missing methods to a given @context variable.
  #
  # This allows code such as adapter and navigation blocks to be evaluated with access to methods from
  # both the Adapter/Navigation instance, as well as the controller/view from where they are invoked.
  module EvaluationContext
  protected
    def self.ruby2_keywords(*)
    end unless respond_to?(:ruby2_keywords, true)

    # Missing methods are called on the given context if available.
    #
    # We include private methods as methods such as current_user
    # are usually declared as private or protected.
    ruby2_keywords def method_missing(name, *args, &block)
      if context_responds_to?(name)
        @context.send(name, *args, &block)
      else
        super
      end
    end

    def respond_to_missing?(name, include_private=false)
      context_responds_to?(name) || super
    end

  private
    def context_responds_to?(name)
      @context && @context.respond_to?(name, true)
    end
  end
end
