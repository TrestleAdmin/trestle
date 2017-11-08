module Trestle
  module DialogHelper
    def dialog_request?
      request.headers["X-Trestle-Dialog"]
    end
  end
end
