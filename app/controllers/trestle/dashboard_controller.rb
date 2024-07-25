class Trestle::DashboardController < Trestle::ApplicationController
  def index
    if Trestle.config.root != Trestle.config.path
      redirect_to Trestle.config.root and return
    end

    admin = primary_admin
    redirect_to admin.path if admin
  end

private
  def primary_admin
    if navigation = Trestle.navigation(self).first
      navigation.admin
    elsif Trestle.registry.any?
      Trestle.registry.first
    end
  end
end
