module Trestle
  module FormHelper
    def trestle_form_for(instance, options={}, &block)
      options[:builder] ||= Form::Builder
      options[:as] ||= admin.admin_name.singularize

      form_for(instance, options) do |f|
        with_form(f) { yield }
      end
    end

    def with_form(form)
      @_trestle_form = form
      yield form if block_given?
    ensure
      @_trestle_form = nil
    end

    def form
      @_trestle_form
    end
  end
end
