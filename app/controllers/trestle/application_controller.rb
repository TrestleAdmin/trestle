module Trestle
  class ApplicationController < ActionController::Base
    protect_from_forgery

    include Controller::Breadcrumbs
    include Controller::Callbacks
    include Controller::Dialog
    include Controller::Helpers
    include Controller::Layout
    include Controller::Location
    include Controller::Title
    include Controller::Toolbars
  end
end
