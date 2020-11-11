class Trestle::AdminController < Trestle::ApplicationController
  def index
  end

  class << self
    attr_reader :admin

  private
    def local_prefixes
      return admin.view_path_prefixes if admin
      [controller_path.sub(/\/$/, "")]
    end
  end

  def admin
    @_admin ||= self.class.admin.new(self)
  end
  helper_method :admin

protected
  def breadcrumbs
    @_breadcrumbs ||= admin.breadcrumbs.dup
  end

  def flash_message(type, title:, message:)
    {
      title:   admin.t("flash.#{type}.title", default: title),
      message: admin.t("flash.#{type}.message", default: message)
    }
  end
end
