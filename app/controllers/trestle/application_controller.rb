class Trestle::ApplicationController < ActionController::Base
  protect_from_forgery

  layout :choose_layout

  # Global helpers
  self.helpers_path += Rails.application.helpers_paths
  helper Trestle.config.helper_module
  helper *Trestle.config.helpers

  # Global callbacks
  Trestle.config.before_actions.each do |action|
    before_action(action.options, &action.block)
  end

  Trestle.config.after_actions.each do |action|
    after_action(action.options, &action.block)
  end

  Trestle.config.around_actions.each do |action|
    around_action(action.options, &action.block)
  end

protected
  def breadcrumbs
    @breadcrumbs ||= Trestle::Breadcrumb::Trail.new(Trestle.config.root_breadcrumbs)
  end
  helper_method :breadcrumbs

  def breadcrumb(label, path=nil)
    breadcrumbs.append(label, path)
  end
  helper_method :breadcrumb

  def choose_layout
    request.xhr? ? false : "trestle/admin"
  end
end
