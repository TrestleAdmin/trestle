module Trestle
  module HeadingsHelper
    def h1(text, options={})
      content_tag(:h1, text, options)
    end

    def h2(text, options={})
      content_tag(:h2, text, options)
    end

    def h3(text, options={})
      content_tag(:h3, text, options)
    end

    def h4(text, options={})
      content_tag(:h4, text, options)
    end

    def h5(text, options={})
      content_tag(:h5, text, options)
    end

    def h6(text, options={})
      content_tag(:h6, text, options)
    end
  end
end
