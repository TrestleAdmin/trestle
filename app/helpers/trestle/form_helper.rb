module Trestle
  module FormHelper
    IDENTITY_FIELD_ERROR_PROC = Proc.new { |html_tag, instance| html_tag }
    DEFAULT_FORM_CONTROLLERS = %w(keyboard-submit form-loading form-error)

    def trestle_form_for(instance, options={}, &block)
      options[:builder] ||= Form::Builder
      options[:as] ||= admin.parameter_name

      options[:data] ||= {}
      options[:data][:controller] = (DEFAULT_FORM_CONTROLLERS + Array(options[:data][:controller])).join(" ")

      form_for(instance, options) do |f|
        with_identity_field_error_proc do
          with_form(f) { yield f }
        end
      end
    end

    def with_form(form)
      @_trestle_form = form
      yield form if block_given?
    ensure
      @_trestle_form = nil
    end

    def with_identity_field_error_proc
      original_field_error_proc = ::ActionView::Base.field_error_proc
      ::ActionView::Base.field_error_proc = IDENTITY_FIELD_ERROR_PROC

      yield if block_given?
    ensure
      ::ActionView::Base.field_error_proc = original_field_error_proc
    end

    def form
      @_trestle_form
    end

    def sidebar(&block)
      content_for(:sidebar, &block)
    end

    def render_sidebar_as_tab?
      modal_request? && content_for?(:sidebar)
    end
  end
end
