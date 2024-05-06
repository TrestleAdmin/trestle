module Trestle
  class Resource
    module Controller
      module Redirection
      protected
        def redirect_to_return_location(action, instance, default: nil, &block)
          fallback_location = block_given? ? block : default

          if admin.return_locations[action] && !dialog_request?
            location = instance_exec(instance, &admin.return_locations[action])

            case location
            when :back
              redirect_back fallback_location: fallback_location, turbolinks: false
            else
              redirect_to location, turbolinks: false
            end
          else
            redirect_to fallback_location, turbolinks: false
          end
        end
      end
    end
  end
end
