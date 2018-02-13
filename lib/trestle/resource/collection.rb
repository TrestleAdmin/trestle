module Trestle
  class Resource
    class Collection
      delegate :initialize_collection, :paginate, :finalize_collection, :decorate_collection,
               :scopes, :merge_scopes, :column_sorts, :sort, to: :@admin

      def initialize(admin)
        @admin = admin
      end

      def prepare(params)
        collection = initialize_collection(params)
        collection = apply_scopes(collection, params)
        collection = apply_sorting(collection, params)
        collection = paginate(collection, params)
        collection = finalize_collection(collection)
        collection = decorate_collection(collection)
        collection
      end

    private
      def apply_scopes(collection, params)
        unscoped = initialize_collection(params)

        active_scopes(params).reduce(collection) do |collection, scope|
          merge_scopes(collection, scope.apply(unscoped))
        end
      end

      def active_scopes(params)
        scopes.values.select { |s| s.active?(params) }
      end

      def apply_sorting(collection, params)
        return collection unless params[:sort]

        field = params[:sort].to_sym
        order = params[:order].to_s.downcase == "desc" ? :desc : :asc

        if column_sorts.has_key?(field)
          @admin.instance_exec(collection, order, &column_sorts[field])
        else
          sort(collection, field, order)
        end
      end
    end
  end
end
