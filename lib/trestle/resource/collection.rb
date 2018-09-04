module Trestle
  class Resource
    class Collection
      delegate :collection, :paginate, :finalize_collection, :decorate_collection,
               :scopes, :merge_scopes, :column_sorts, :sort, to: :@admin

      def initialize(admin, options={})
        @admin, @options = admin, options
      end

      def prepare(params)
        collection = collection(params)
        collection = apply_scopes(collection, params)  if scope?
        collection = apply_sorting(collection, params) if sort?
        collection = paginate(collection, params)      if paginate?
        collection = finalize_collection(collection)   if finalize?
        collection = decorate_collection(collection)   if decorate?
        collection
      end

      def scope?
        @options[:scope] != false
      end

      def sort?
        @options[:sort] != false
      end

      def paginate?
        @options[:paginate] != false
      end

      def finalize?
        @options[:finalize] != false
      end

      def decorate?
        @options[:decorate] != false
      end

    private
      def apply_scopes(collection, params)
        unscoped = collection(params)

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
