module Trestle
  class Display
    def initialize(instance)
      @instance = instance
    end

    def to_s
      if display_method != :to_s || @instance.method(display_method).source_location
        @instance.public_send(display_method)
      else
        "#{@instance.class} (##{@instance.id})"
      end
    end

  private
    def display_method
      @display_method ||= Trestle.config.display_methods.find { |m| @instance.respond_to?(m) } || :to_s
    end
  end
end
