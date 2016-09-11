module Trestle
  module FormHelper
    def trestle_form_for(instance, options={}, &block)
      options[:builder] ||= Trestle::Form::Builder
      options[:as] ||= admin.admin_name.singularize

      form_for(instance, options) do |f|
        @_trestle_form = f
        yield f if block_given?
        @_trestle_form = nil
      end
    end

    def form
      @_trestle_form
    end
  end
end
