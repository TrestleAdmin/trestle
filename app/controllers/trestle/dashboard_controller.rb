class Trestle::DashboardController < Trestle::ApplicationController
  def index
    redirect_to primary_admin.path
  end

private
  def primary_admin
    if navigation = Trestle.navigation.first
      navigation.admin
    elsif Trestle.admin.values.any?
      Trestle.admin.values.first
    end
  end
end
