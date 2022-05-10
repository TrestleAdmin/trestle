module Trestle
  class Resource
    module Controller
      module Redirection
      protected
        def redirect_to_return_location(action, instance, status: :found, default:)
          if admin.return_locations[action] && !modal_request?
            location = instance_exec(instance, &admin.return_locations[action])

            case location
            when :back
              redirect_back fallback_location: default, status: status
            else
              redirect_to location, status: status
            end
          else
            redirect_to default, status: status
          end
        end
      end
    end
  end
end
