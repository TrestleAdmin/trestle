class Trestle::ApplicationController < ActionController::Base
  layout 'trestle/admin'

protected
  def breadcrumbs
    @breadcrumbs ||= Trestle::Breadcrumb::Trail.new(Trestle.config.root_breadcrumb)
  end
  helper_method :breadcrumbs

  def breadcrumb(label, path=nil)
    breadcrumbs.append(label, path)
  end
  helper_method :breadcrumb
end
