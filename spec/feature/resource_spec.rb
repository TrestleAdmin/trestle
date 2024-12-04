require 'spec_helper'

feature 'Resources', type: :system do
  include FeatureHelper

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

    within('tbody tr:first-child .table-actions') { click_link }
    confirm_delete

    expect(page).to have_content("The post was successfully deleted.")
    expect(page).not_to have_content("First Post")
  end
end
