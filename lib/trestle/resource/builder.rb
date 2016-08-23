module Trestle
  class Resource
    class Builder < Admin::Builder
      self.admin_class = Resource
      self.controller = Controller
    end
  end
end
