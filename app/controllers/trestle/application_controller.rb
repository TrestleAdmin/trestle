class Trestle::ApplicationController < ActionController::Base
  protect_from_forgery

  include Trestle::Controller::Breadcrumbs
  include Trestle::Controller::Callbacks
  include Trestle::Controller::Helpers
  include Trestle::Controller::Layout
end
