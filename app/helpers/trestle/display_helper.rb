module Trestle
  module DisplayHelper
    # Returns a plain-text representation of the given model instance,
    # typically used when rendering an associated object within a table.
    #
    # This helper delegates to Trestle::Display, which works by checking the
    # existence of each method from `Trestle.config.display_methods` in turn
    # and calling the first one it finds.
    #
    # By default this list is set to:
    #
    #   [:display_name, :full_name, :name, :title, :username, :login, :email]
    #
    def display(instance)
      Trestle::Display.new(instance).to_s
    end
  end
end
