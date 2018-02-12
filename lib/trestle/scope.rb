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
      @admin.scopes_for(params).include?(self)
    end
  end
end
