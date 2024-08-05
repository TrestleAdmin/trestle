class Trestle::ApplicationController < ActionController::Base
  protect_from_forgery

  include Trestle::Controller::Breadcrumbs
  include Trestle::Controller::Callbacks
  include Trestle::Controller::Helpers
  include Trestle::Controller::Layout
  include Trestle::Controller::Location
  include Trestle::Controller::Modal
  include Trestle::Controller::Title
  include Trestle::Controller::Toolbars
  include Trestle::Controller::TurboStream
end
