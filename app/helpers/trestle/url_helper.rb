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
    # content  - HTML or text content to use as the link content
    #            (will be ignored if a block is provided)
    # instance - Optional model instance, or explicit String path
    # admin    - Optional admin instance to link to. Will be inferred from instance if provided,
    #            otherwise falling back to the current admin if available
    # action   - Optional admin action to link to. Will default to :show if instance is provided,
    #            otherwise the admin's root action (usually :index) will be used
    # method   - Optional request method (e.g. :delete), that will be set as `data-turbo-method`
    # params   - Hash of URL parameters to pass to `instance_path` or `path` admin methods (default: {})
    # options  - Hash of options to forward to the `link_to` helper (default: {})
    # block    - Optional block to capture to use as the link content
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
    def admin_link_to(content=nil, instance=nil, admin: nil, action: nil, method: nil, params: {}, **options, &block)
      # Block given - ignore content parameter and capture content from block
      if block_given?
        instance, content = content, capture(&block)
      end

      # Treat string URL as regular link
      if instance.is_a?(String)
        return link_to(content, instance, options)
      end

      # Determine target admin
      target = lookup_admin_from_options(
        instance: instance,
        admin: admin,
        fallback: self&.admin,
        raise: true
      )

      # Set default action depending on instance or not
      action ||= (instance ? :show : target.root_action)

      path = admin_url_for(instance, admin: target, action: action, **params)

      # Determine link data options
      options[:data] ||= {}

      if MODAL_ACTIONS.include?(action) && target&.form&.modal?
        options[:data][:controller] ||= "modal-trigger"
      else
        options[:data][:turbo_frame] ||= (modal_request? ? "modal" : "_top")
      end

      options[:data][:turbo_method] ||= method if method

      link_to(content, path, options)
    end

    # Returns the admin path for a given instance.
    #
    # An admin can either be explicitly specified (as a symbol or admin class),
    # or it can be automatically inferred based the instance type using `admin_for`.
    #
    # instance - The model instance to generate a path for
    # admin    - Optional admin (symbol or admin class)
    # action   - Optional admin action to generate the URL for. Will default to :show if
    #            instance is provided, otherwise the admin's root action (usually :index)
    #            will be used
    # raise    - Whether to raise a ActionController::UrlGenerationError if the admin
    #            cannot be determined, either from the admin parameter or automatically
    # params   - Hash of URL parameters to pass to `instance_path` or `path` admin methods
    #
    # Examples
    #
    #   <%= admin_url_for(article, action: :edit) %>
    #   <%= admin_url_for(article, admin: :special_articles) %>
    #
    # Returns a String, or nil if the admin cannot be automatically inferred.
    def admin_url_for(instance=nil, admin: nil, action: nil, raise: false, **params)
      target = lookup_admin_from_options(
        instance: instance,
        admin: admin,
        fallback: self&.admin,
        raise: raise
      )
      return unless target

      # Set default action depending on instance or not
      action ||= (instance ? :show : target.root_action)

      if instance
        if target.respond_to?(:instance_path)
          target.instance_path(instance, action: action, **params)
        else
          target.path(action, params.merge(id: target.to_param(instance)))
        end
      else
        target.path(action, params)
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

  private
    def lookup_admin_from_options(instance: nil, admin: nil, fallback: nil, raise: true)
      if admin
        result = Trestle.lookup(admin)
      elsif instance
        result = Trestle.lookup_model(instance.class) || fallback
      else
        result = fallback
      end

      if result
        # Instantiate admin with current context
        result = result.new(self) if result.is_a?(Class)

        result
      elsif raise
        raise ActionController::UrlGenerationError,
          "An admin could not be inferred. Please specify an admin using the :admin option."
      end
    end
  end
end
