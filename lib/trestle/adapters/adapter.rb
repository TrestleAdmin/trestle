module Trestle
  module Adapters
    class Adapter
      attr_reader :admin
      delegate :model, to: :admin

      def initialize(admin, context=nil)
        @admin = admin
        @context = context
      end

      # Loads the initial collection for use by the index action.
      #
      # params - Unfiltered params hash from the controller
      #
      # Returns a scope object that can be chained with other methods (e.g. sort, paginate, count, etc).
      def collection(params={})
        raise NotImplementedError
      end

      # Finds (and returns) an individual instance for use by the show, edit, update, destroy actions.
      #
      # params - Unfiltered params hash from the controller
      def find_instance(params)
        raise NotImplementedError
      end

      # Builds (and returns) a new instance for new/create actions.
      #
      # attrs  - Permitted attributes to set on the new instance
      # params - Unfiltered params hash from the controller
      def build_instance(attrs={}, params={})
        raise NotImplementedError
      end

      # Updates (but does not save) a given resource's attributes.
      #
      # instance - The instance to update
      # attrs    - Permitted attributes to update on the instance
      # params   - Unfiltered params hash from the controller
      #
      # The return value is ignored.
      def update_instance(instance, attrs, params={})
        raise NotImplementedError
      end

      # Saves an instance (used by the create and update actions).
      #
      # instance - The instance to save
      # params   - Unfiltered params hash from the controller
      #
      # Returns a boolean indicating the success/fail status of the save.
      def save_instance(instance, params={})
        raise NotImplementedError
      end

      # Deletes an instance (used by the destroy action).
      #
      # instance - The instance to delete
      # params   - Unfiltered params hash from the controller
      #
      # Returns a boolean indicating the success/fail status of the deletion.
      def delete_instance(instance, params={})
        raise NotImplementedError
      end

      # Finalizes a collection so that it can be rendered within the index view.
      #
      # In most cases (e.g. ActiveRecord), no finalization is required. However if you are using a search library then
      # you may need to explicitly execute the search, or access the models via a #records or #objects method.
      #
      # collection - The collection to finalize
      #
      # Returns an enumerable collection of instances.
      def finalize_collection(collection)
        collection
      end

      # Decorates a collection for rendering by the index view.
      # Decorating is the final step in preparing the collection for the view.
      #
      # collection - The collection to decorate
      #
      # Returns an enumerable collection of instances.
      def decorate_collection(collection)
        collection
      end

      # Converts an instance to a URL parameter. The result of this method is passed to the #find_instance
      # adapter method as params[:id]. It is recommended to simply use the instance's #id, as other potential options
      # such as a permalink/slug could potentially be changed during editing.
      #
      # instance - The instance to convert
      #
      # Returns the URL representation of the instance.
      def to_param(instance)
        instance.id
      end

      # Merges scopes together for Trestle scope application and counting.
      #
      # scope - The first scope
      # other - The second scope
      #
      # Returns a scope object representing the combination of the two given scopes.
      def merge_scopes(scope, other)
        raise NotImplementedError
      end

      # Counts the number of objects in a collection for use by scope links.
      #
      # collection - The collection to count
      #
      # Returns the total number (integer) of objects in the collection.
      def count(collection)
        raise NotImplementedError
      end

      # Sorts the collection by the given field and order.
      # This method is called when an explicit sort column for the given field is not defined.
      #
      # collection - The collection to sort
      # field      - The field to sort by
      # order      - Symbol (:asc or :desc) representing the sort order (ascending or descending)
      #
      # Returns a scope object
      def sort(collection, field, order)
        raise NotImplementedError
      end

      # Paginates a collection for use by the index action.
      #
      # collection - The collection to paginate
      # params     - Unfiltered params hash from the controller:
      #              :page - current page number
      #
      # Returns a Kaminari-compatible scope corresponding to a single page.
      def paginate(collection, params)
        collection = Kaminari.paginate_array(collection.to_a) unless collection.respond_to?(Kaminari.config.page_method_name)
        per_page = admin.pagination_options[:per]

        collection.public_send(Kaminari.config.page_method_name, params[:page]).per(per_page)
      end

      # Filters the submitted form parameters and returns a whitelisted attributes 'hash'
      # that can be set or updated on a model instance.
      #
      # IMPORTANT: By default, all params are permitted, which assumes a trusted administrator. If this is not the
      # case, a `params` block should be individually declared for each admin with the set of permitted parameters.
      #
      # params - Unfiltered params hash from the controller
      #
      # Returns the permitted set of parameters as a ActionController::Parameters object.
      def permitted_params(params)
        params.require(admin.parameter_name).permit!
      end

      # Produces a human-readable name for a given attribute, applying I18n where appropriate.
      # See ActiveModel::Translation for an implementation of this method.
      #
      # attribute - Attribute name (Symbol)
      # options   - Hash of options [not currently used]
      #
      # Returns the human-readable name of the given attribute as a String.
      def human_attribute_name(attribute, options={})
        attribute.to_s.titleize
      end

      # Generates a list of attributes that should be rendered by the index (table) view.
      #
      # Returns an Array of Trestle::Attribute and/or Trestle::Attribute::Association objects.
      def default_table_attributes
        raise NotImplementedError
      end

      # Generates a list of attributes that should be rendered by the new/show/edit (form) views.
      #
      # Returns an Array of Trestle::Attribute and/or Trestle::Attribute::Association objects.
      def default_form_attributes
        raise NotImplementedError
      end

    protected
      # Missing methods are called on the given context if available.
      #
      # We include private methods as methods such as current_user
      # are usually declared as private or protected.
      def method_missing(name, *args, &block)
        if @context && @context.respond_to?(name, true)
          @context.send(name, *args, &block)
        else
          super
        end
      end

      def respond_to_missing?(name, include_private=false)
        (@context && @context.respond_to?(name, true)) || super
      end
    end
  end
end
