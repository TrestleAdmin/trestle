module Trestle
  module ParamsHelper
    # Returns a subset of the params "hash" (an instance of ActionController::Parameters)
    # limited to only those keys that should be considered persistent throughout
    # reordering and pagination.
    #
    # This could be a scope or the current order, but this may be extended by Trestle
    # plugins and the application itself in `Trestle.config.persistent_params` to include
    # search queries, filters, etc.
    #
    # By default this list is set to: [:sort, :order, :scope]
    #
    # Returns an instance of ActionController::Parameters.
    def persistent_params
      flat, nested = Trestle.config.persistent_params.partition { |p| !p.is_a?(Hash) }
      nested = nested.inject({}) { |result, param| result.merge(param) }

      params.slice(*(flat + nested.keys)).permit(*(flat << nested))
    end

    # Converts the current set of persistent params into hidden form fields, suitable
    # for inclusion within a form tag (e.g for search or filtering).
    #
    # except - List of param keys to exclude
    # only   - List of param keys to only include
    #
    # Returns a HTML-safe String.
    def serialize_persistent_params(except: [], only: [])
      params = persistent_params

      if Array(only).any?
        params = params.slice(*only)
      elsif Array(except).any?
        params = params.except(*except)
      end

      safe_join(to_form_params(params).map { |param|
        tag.input(type: "hidden", name: param[:name], value: param[:value], autocomplete: "off")
      }, "\n")
    end
  end
end
