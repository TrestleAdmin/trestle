require 'spec_helper'

feature 'Modal forms', js: true do
  include FeatureHelper

  scenario 'index' do
    create_test_post

    visit '/admin/modal'
    expect(page).to have_content "First Post"
  end

  scenario 'new record' do
    visit '/admin/modal'
    click_link "New Post"

    fill_in "Title", with: "Post Title"
    fill_in "Body", with: "Post body goes here"
    click_button "Save Post"

    expect(page).to have_content("The post was successfully created.")
    expect(page).to have_current_path(/\/admin\/modal/)
  end

  scenario 'update record' do
    create_test_post

    visit '/admin/modal'
    click_link "First Post"

    fill_in "Title", with: "Updated Title"
    click_button "Save Post"

    expect(page).to have_content("The post was successfully updated.")
  end

  scenario 'delete record' do
    create_test_post

    visit '/admin/modal'
    click_link "First Post"

    within_modal { click_link "Delete Post" }
    confirm_delete

    expect(page).to have_content("The post was successfully deleted.")
    expect(page).not_to have_content("First Post")
  end
end
