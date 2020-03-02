module Trestle
  class Resource
    class Controller < Admin::Controller
      include Controller::Actions
      include Controller::DataMethods
      include Controller::Redirection
      include Controller::Toolbar
    end
  end
end
