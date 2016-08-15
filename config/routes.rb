Trestle::Engine.routes.draw do
  Trestle.admins.each do |name, admin|
    instance_eval(&admin.routes)
  end
end
