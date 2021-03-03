Trestle::Engine.routes.draw do
  Trestle.registry.each do |admin|
    instance_eval(&admin.routes)
  end

  root to: "trestle/dashboard#index"
end
