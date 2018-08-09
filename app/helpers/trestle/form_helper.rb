module Trestle
  module FormHelper
    def trestle_form_for(instance, options={}, &block)
      options[:builder] ||= Form::Builder
      options[:as] ||= admin.parameter_name

      options[:data] ||= {}
      options[:data].reverse_merge!(remote: true, type: :html, behavior: "trestle-form", turbolinks: false)

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

    def sidebar(&block)
      content_for(:sidebar, &block)
    end

    def render_sidebar_as_tab?
      dialog_request? && content_for?(:sidebar)
    end
  end
end
