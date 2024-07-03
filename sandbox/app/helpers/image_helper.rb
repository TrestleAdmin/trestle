module ImageHelper
  def random_image(width, height, seed=nil)
    image_tag(random_image_url(width, height, seed))
  end

  def random_image_url(width, height, seed=nil)
    "https://picsum.photos/seed/#{seed}/#{width}/#{height}?random"
  end
end
