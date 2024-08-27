module Trestle
  module FormHelper
    # Generates a form for a resource using Rails' #form_for helper.
    #
    # In addition to delegating to #form_for, this helper method:
    #
    # 1) Sets the default form builder to `Trestle::Form::Builder`.
    # 2) Sets the default :as option to match the parameter name
    #    expected by the admin.
    # 3) Sets default Stimulus controllers on the <form> element
    #    from `Trestle.config.default_form_controllers`.
    #    (defaults to: "keyboard-submit form-loading form-error")
    # 4) Sets a null/identity ActionView::Base.field_error_proc as
    #    errors are handled by Trestle::Form::Fields::FormGroup.
    # 5) Exposes the yielded form builder instance via the `form` helper.
    #
    # Examples
    #
    #   <%= trestle_form_for(article, url: admin.instance_path(instance, action: :update),
    #                                 method: :patch) do %> ...
    #
    # Returns a HTML-safe String. Yields the form builder instance.
    def trestle_form_for(instance, **options, &block)
      options[:builder] ||= Form::Builder
      options[:as] ||= admin.parameter_name

      options[:data] ||= {}
      options[:data][:controller] = (Trestle.config.default_form_controllers + Array(options[:data][:controller])).join(" ")

      form_for(instance, **options) do |f|
        with_identity_field_error_proc do
          with_form(f) { yield f }
        end
      end
    end

    # Returns the currently scoped Trestle form builder
    # (a subclass of ActionView::Helpers::FormBuilder).
    def form
      @_trestle_form
    end

  protected
    def with_form(form)
      @_trestle_form = form
      yield form if block_given?
    ensure
      @_trestle_form = nil
    end

    IDENTITY_FIELD_ERROR_PROC = Proc.new { |html_tag, instance| html_tag }

    def with_identity_field_error_proc
      original_field_error_proc = ::ActionView::Base.field_error_proc
      ::ActionView::Base.field_error_proc = IDENTITY_FIELD_ERROR_PROC

      yield if block_given?
    ensure
      ::ActionView::Base.field_error_proc = original_field_error_proc
    end
  end
end
