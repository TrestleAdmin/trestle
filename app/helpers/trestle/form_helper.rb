module Trestle
  module FormHelper
    def trestle_form_for(instance, options={}, &block)
      options[:builder] ||= Form::Builder
      options[:as] ||= admin.admin_name.singularize

      form_for(instance, options) do |f|
        with_form(f) { yield f }
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

    def toolbar(name, &block)
      content_for(:"#{name}_toolbar", &block)
    end

    def sidebar(&block)
      content_for(:sidebar, &block)
    end
  end
end
