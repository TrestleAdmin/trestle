require 'spec_helper'

feature 'Resources' do
  scenario 'index' do
    create_test_post

    visit '/admin/posts'
    expect(page).to have_content "First Post"
  end

  scenario 'new record' do
    visit '/admin/posts'
    click_link "New Post"

    fill_in "Title", with: "Post Title"
    fill_in "Body", with: "Post body goes here"
    click_button "Save Post"

    expect(page).to have_content("The post was successfully created.")
    expect(page).to have_current_path(/\/admin\/posts\/\d+/)
  end

  scenario 'update record' do
    create_test_post

    visit '/admin/posts'
    click_link "First Post"

    fill_in "Title", with: "Updated Title"
    click_button "Save Post"

    expect(page).to have_content("The post was successfully updated.")
  end

  scenario 'delete record' do
    create_test_post

    visit '/admin/posts'
    within('tbody tr:first .actions') { click_link }

    expect(page).to have_content("The post was successfully deleted.")
    expect(page).not_to have_content("First Post")
  end

  def create_test_post
    Post.create!(id: 1, title: "First Post", body: "This is a test post", published: true)
  end
end
