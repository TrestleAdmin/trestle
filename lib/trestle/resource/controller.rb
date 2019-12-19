module Trestle
  class Resource
    class Controller < Admin::Controller
      extend ActiveSupport::Autoload

      autoload :Actions
      autoload :DataMethods
      autoload :Redirection

      include Actions
      include DataMethods
      include Redirection
    end
  end
end
