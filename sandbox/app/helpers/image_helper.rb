module ImageHelper
  def random_image(width, height, query=nil)
    image_tag(random_image_url(width, height, query))
  end

  def random_image_url(width, height, query=nil)
    "https://source.unsplash.com/#{width}x#{height}?#{query}"
  end
end
