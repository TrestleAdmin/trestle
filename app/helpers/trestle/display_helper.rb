module Trestle
  module DisplayHelper
    def display(instance)
      Trestle::Display.new(instance).to_s
    end
  end
end
