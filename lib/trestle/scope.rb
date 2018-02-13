module Trestle
  class Scope
    attr_reader :name, :options, :block

    def initialize(admin, name, options={}, &block)
      @admin, @name, @options, @block = admin, name, options, block
    end

    def to_param
      name
    end

    def label
      @options[:label] || I18n.t("admin.scopes.#{name}", default: name.to_s.humanize.titleize)
    end

    def default?
      @options[:default] == true
    end

    def apply(collection)
      if @block
        if @block.arity == 1
          @admin.instance_exec(collection, &@block)
        else
          @admin.instance_exec(&@block)
        end
      else
        collection.public_send(name)
      end
    end

    def count(collection)
      @admin.count(@admin.merge_scopes(collection, apply(collection)))
    end

    def active?(params)
      active_scopes = Array(params[:scope])

      if active_scopes.any?
        active_scopes.include?(to_param.to_s)
      else
        default?
      end
    end
  end
end
