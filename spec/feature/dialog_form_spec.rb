require 'spec_helper'

feature 'Dialog forms', js: true do
  scenario 'index' do
    create_test_post

    visit '/admin/dialog'
    expect(page).to have_content "First Post"
  end

  scenario 'new record' do
    visit '/admin/dialog'
    click_link "New Post"

    fill_in "Title", with: "Post Title"
    fill_in "Body", with: "Post body goes here"
    click_button "Save Post"

    expect(page).to have_content("The post was successfully created.")
    expect(page).to have_current_path(/\/admin\/dialog/)
  end

  scenario 'update record' do
    create_test_post

    visit '/admin/dialog'
    click_link "First Post"

    fill_in "Title", with: "Updated Title"
    click_button "Save Post"

    expect(page).to have_content("The post was successfully updated.")
  end

  scenario 'delete record' do
    create_test_post

    visit '/admin/dialog'
    click_link "First Post"

    within_modal { click_link "Delete Post" }
    within_popover { click_link "Delete" }

    expect(page).to have_content("The post was successfully deleted.")
    expect(page).not_to have_content("First Post")
  end

  def create_test_post
    Post.create!(id: 1, title: "First Post", body: "This is a test post", published: true)
  end

  def within_modal(&block)
    delay
    within('.modal', &block)
  end

  def within_popover(&block)
    delay
    within('.popover', &block)
  end

  def delay
    sleep 0.5
  end
end
