require 'spec_helper'

feature 'Singular resources' do
  scenario 'show' do
    create_test_post

    visit '/admin/singular_post'

    expect(page).to have_form("/admin/singular_post", "post") {
      with_text_field "singular_post[title]", "Single Post"
      with_text_area "singular_post[body]"
    }
  end

  scenario 'update record' do
    create_test_post

    visit '/admin/singular_post'

    fill_in "Title", with: "Updated Title"
    click_button "Save Post"

    expect(page).to have_content("The post was successfully updated.")
    expect(page).to have_current_path(/\/admin\/singular_post/)
  end

  def create_test_post
    Post.create!(id: 1, title: "Single Post", body: "This is a singular post", published: true)
  end
end
