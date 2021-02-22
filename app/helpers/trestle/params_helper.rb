module Trestle
  module ParamsHelper
    def persistent_params
      flat, nested = Trestle.config.persistent_params.partition { |p| !p.is_a?(Hash) }
      nested = nested.inject({}) { |result, param| result.merge(param) }

      params.slice(*(flat + nested.keys)).permit(*(flat << nested))
    end
  end
end
