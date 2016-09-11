Trestle::Engine.routes.draw do
  root to: "trestle/dashboard#index"
  
  Trestle.admins.each do |name, admin|
    instance_eval(&admin.routes)
  end
end
