module Trestle
  module ParamsHelper
    def persistent_params
      params.slice(*Trestle.config.persistent_params).permit(*Trestle.config.persistent_params)
    end
  end
end
