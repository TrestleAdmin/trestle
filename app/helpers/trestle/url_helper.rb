module Trestle
  module UrlHelper
    MODAL_ACTIONS = [:new, :show, :edit]

    # Generates a link to an admin, optionally for a specific instance on a resourceful admin.
    #
    # It has a few additional conveniences over using the standard `link_to` helper:
    #
    # 1) It can automatically infer the admin from the given instance.
    # 2) It will automatically add data-controller="modal-trigger" when linking to a form
    #    action that is set to show as a modal.
    # 3) It sets data-turbo-frame appropriately for modal and non-modal contexts to ensure
    #    the admin can correctly detect modal requests.
    #
    # content         - HTML or text content to use as the link content
    #                   (will be ignored if a block is provided)
    # instance_or_url - model instance, or explicit String path
    # options         - Hash of options (default: {})
    #                   :admin  - Optional explicit admin (symbol or admin class)
    #                   :action - Controller action to generate the link to
    #                   :params - Additional params to use when generating the link URL
    #                   (all other options are forwarded to the `link_to` helper)
    # block           - Optional block to capture to use as the link content
    #
    # Examples
    #
    #   <%= admin_link_to article.name, article %>
    #
    #   <%= admin_link_to admin: :dashboard, action: :index do %>
    #     <%= icon "fas fa-gauge" %> Dashboard
    #   <% end %>
    #
    # Returns a HTML-safe String.
    # Raises ActionController::UrlGenerationError if the admin cannot be automatically inferred.
    def admin_link_to(content, instance_or_url=nil, options={}, &block)
      # Block given - ignore content parameter and capture content from block
      if block_given?
        instance_or_url, options = content, instance_or_url || {}
        content = capture(&block)
      end

      if instance_or_url.is_a?(String)
        # Treat string URL as regular link
        link_to(content, instance_or_url, options)
      else
        # Normalize options if instance is not provided
        if instance_or_url.is_a?(Hash)
          instance, options = nil, instance_or_url
        else
          instance = instance_or_url
        end

        # Determine admin
        if options.key?(:admin)
          admin = Trestle.lookup(options.delete(:admin))
        elsif instance
          admin = admin_for(instance)
        end

        admin ||= self.admin if respond_to?(:admin)

        if admin
          # Ensure admin has controller context
          admin = admin.new(self) if admin.is_a?(Class)

          # Generate path
          action = options.delete(:action) || :show
          params = options.delete(:params) || {}

          if admin.respond_to?(:instance_path) && instance
            path = admin.instance_path(instance, params.reverse_merge(action: action))
          else
            params[:id] ||= admin.to_param(instance) if instance
            path = admin.path(action, params)
          end

          # Determine link data options
          options[:data] ||= {}

          if MODAL_ACTIONS.include?(action) && admin.respond_to?(:form) && admin.form.modal?
            options[:data][:controller] ||= "modal-trigger"
          else
            options[:data][:turbo_frame] ||= (modal_request? ? "modal" : "_top")
          end

          link_to(content, path, options)
        else
          raise ActionController::UrlGenerationError, "An admin could not be inferred. Please specify an admin using the :admin option."
        end
      end
    end

    # Returns the admin path for a given instance.
    #
    # An admin can either be explicitly specified (as a symbol or admin class),
    # or it can be automatically inferred based the instance type using `admin_for`.
    #
    # instance - The model instance to generate a path for
    # admin    - Optional admin (symbol or admin class)
    # options  - Hash of options to pass to `instance_path` or `path` admin methods
    #
    # Examples
    #
    #   <%= admin_url_for(article, action: :edit) %>
    #   <%= admin_url_for(article, admin: :special_articles) %>
    #
    # Returns a String, or nil if the admin cannot be automatically inferred.
    def admin_url_for(instance, admin: nil, **options)
      admin = Trestle.lookup(admin) if admin
      admin ||= admin_for(instance)
      return unless admin

      # Ensure admin has controller context
      admin = admin.new(self) if admin.is_a?(Class)

      if admin.respond_to?(:instance_path)
        admin.instance_path(instance, options)
      else
        admin.path(options[:action] || :show, id: admin.to_param(instance))
      end
    end

    # Looks up the registered Trestle admin for a given model instance.
    #
    # The lookup is performed on the global `Trestle::Registry` instance,
    # which tracks admin resource models unless the resource was created
    # with `register_model: false`.
    #
    # instance - The model instance to look up in the registry
    #
    # Returns a Trestle::Admin subclass or nil if no matching admin found.
    def admin_for(instance)
      Trestle.lookup_model(instance.class)
    end
  end
end
