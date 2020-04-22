module Trestle
  class ResourceController < AdminController
    include Resource::Controller::Actions
    include Resource::Controller::DataMethods
    include Resource::Controller::Redirection
    include Resource::Controller::Toolbar
  end
end
