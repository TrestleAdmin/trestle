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
        @block.call
      else
        collection.public_send(name)
      end
    end

    def count(collection)
      @admin.count(@admin.merge_scopes(collection, apply(@admin.unscope(collection))))
    end

    def active?(params)
      @admin.scopes_for(params).include?(self)
    end
  end
end
