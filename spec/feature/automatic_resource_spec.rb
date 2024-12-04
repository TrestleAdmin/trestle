require 'spec_helper'

feature 'Automatic resources', type: :system do
  include FeatureHelper

  scenario 'index' do
    create_test_post

    visit '/admin/automatic'
    expect(page).to have_content "First Post"
  end

  scenario 'new record' do
    visit '/admin/automatic'
    click_link "New Post"

    fill_in "Title", with: "Post Title"
    fill_in "Body", with: "Post body goes here"
    check "Published"
    click_button "Save Post"

    expect(page).to have_content("The post was successfully created.")
    expect(page).to have_current_path(/\/admin\/automatic\/\d+/)
  end

  scenario 'update record' do
    create_test_post

    visit '/admin/automatic'
    click_link "1"

    fill_in "Title", with: "Updated Title"
    click_button "Save Post"

    expect(page).to have_content("The post was successfully updated.")
  end

  scenario 'delete record' do
    create_test_post

    visit '/admin/automatic'

    within('tbody tr:first-child .table-actions') { click_link }
    confirm_delete

    expect(page).to have_content("The post was successfully deleted.")
    expect(page).not_to have_content("First Post")
  end
end
