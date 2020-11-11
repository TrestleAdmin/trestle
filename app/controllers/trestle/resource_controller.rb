class Trestle::ResourceController < Trestle::AdminController
  include Trestle::Resource::Controller::Actions
  include Trestle::Resource::Controller::DataMethods
  include Trestle::Resource::Controller::Redirection
  include Trestle::Resource::Controller::Toolbar
end
