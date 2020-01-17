module Trestle
  class Resource
    class Controller < Admin::Controller
      extend ActiveSupport::Autoload

      autoload :Actions
      autoload :DataMethods
      autoload :Redirection
      autoload :Toolbar

      include Actions
      include DataMethods
      include Redirection
      include Toolbar
    end
  end
end
