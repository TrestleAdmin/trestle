module Trestle
  # This module facilitiates the delegation of missing methods to a given @context variable.
  #
  # This allows code such as adapter and navigation blocks to be evaluated with access to methods from
  # both the Adapter/Navigation instance, as well as the controller/view from where they are invoked.
  module EvaluationContext
  protected
    # Missing methods are called on the given context if available.
    #
    # We include private methods as methods such as current_user
    # are usually declared as private or protected.
    def method_missing(name, *args, **kwargs, &block)
      if @context && @context.respond_to?(name, true)
        @context.send(name, *args, **kwargs, &block)
      else
        super
      end
    end

    def respond_to_missing?(name, include_private=false)
      (@context && @context.respond_to?(name, true)) || super
    end
  end
end
