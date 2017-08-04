class Trestle::ApplicationController < ActionController::Base
  protect_from_forgery

  layout 'trestle/admin'

  # Global helpers
  self.helpers_path += Rails.application.helpers_paths
  helper *Trestle.config.helpers

protected
  def breadcrumbs
    @breadcrumbs ||= Trestle::Breadcrumb::Trail.new(Trestle.config.root_breadcrumbs)
  end
  helper_method :breadcrumbs

  def breadcrumb(label, path=nil)
    breadcrumbs.append(label, path)
  end
  helper_method :breadcrumb
end
