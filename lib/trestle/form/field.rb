module Trestle
  class Form
    class Field
      attr_reader :builder, :template, :name, :options, :block

      delegate :admin, :content_tag, :concat, :safe_join, :icon, to: :template

      def initialize(builder, template, name, options={}, &block)
        @builder, @template, @name, @block = builder, template, name, block

        assign_options!(options)
        normalize_options!
      end

      def errors
        error_keys.map { |key| builder.errors(key) }.flatten
      end

      def form_group(opts={})
        @builder.form_group(name, @wrapper.merge(opts)) do
          yield
        end
      end

      def render
        if @wrapper
          form_group do
            field
          end
        else
          field
        end
      end

      def field
        raise NotImplementedError
      end

      def defaults
        Trestle::Options.new(readonly: readonly?)
      end

      def readonly?
        options[:readonly] || admin.readonly?
      end

      def normalize_options!
        extract_wrapper_options!
        assign_error_class!
      end

    protected
      def assign_options!(options)
        # Assign @options first so that it can be referenced from within #defaults if required
        @options = Trestle::Options.new(options)
        @options = defaults.merge(options)
      end

      def extract_wrapper_options!
        unless options[:wrapper] == false
          @wrapper = extract_wrapper_options(*Fields::FormGroup::WRAPPER_OPTIONS).merge(options.delete(:wrapper))
        end
      end

      def assign_error_class!
        @options[:class] = Array(@options[:class])
        @options[:class] << error_class if errors.any?
      end

      def error_class
        "is-invalid"
      end

      def error_keys
        keys = [name]

        # Singular associations (belongs_to)
        keys << name.to_s.sub(/_id$/, '') if name.to_s =~ /_id$/

         # Collection associations (has_many / has_and_belongs_to_many)
        keys << name.to_s.sub(/_ids$/, 's') if name.to_s =~ /_ids$/

        keys
      end

      def extract_wrapper_options(*keys)
        wrapper = Trestle::Options.new
        keys.each { |k| wrapper[k] = options.delete(k) if options.key?(k) }
        wrapper
      end
    end
  end
end
