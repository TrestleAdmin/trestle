class Trestle::ApplicationController < ActionController::Base
  protect_from_forgery

  layout 'trestle/admin'

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
