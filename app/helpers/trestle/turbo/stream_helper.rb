module Trestle
  module Turbo
    module StreamHelper
      def turbo_stream
        Trestle::Turbo::TagBuilder.new(self)
      end
    end
  end
end
