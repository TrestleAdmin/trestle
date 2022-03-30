module FeatureHelper
  def create_test_post
    Post.create!(id: 1, title: "First Post", body: "This is a test post", published: true)
  end

  def within_modal(&block)
    within('.modal', &block)
  end

  def within_popover(&block)
    within('.popover', &block)
  end

  def confirm_delete
    within_popover { click_button "Delete" }
  end
end
