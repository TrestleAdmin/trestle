module Trestle
  module HeadingsHelper
    # These methods are delegated to the ActionView::Helpers::TagHelper proxy object for convenience.
    delegate :h1, :h2, :h3, :h4, :h5, :h6, to: :tag
  end
end
