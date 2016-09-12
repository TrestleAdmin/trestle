class Trestle::DashboardController < Trestle::ApplicationController
  def index
    admin = primary_admin
    redirect_to admin.path if admin
  end

private
  def primary_admin
    if navigation = Trestle.navigation.first
      navigation.admin
    elsif Trestle.admins.values.any?
      Trestle.admins.values.first
    end
  end
end
