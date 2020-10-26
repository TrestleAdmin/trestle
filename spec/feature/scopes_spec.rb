require "spec_helper"

feature "Scopes" do
  before(:each) do
    Post.create!(title: "Unpublished 1")
    Post.create!(title: "Unpublished 2")
    Post.create!(title: "Published 1", published: true)
    Post.create!(title: "Published 2", published: true)
  end

  scenario "Scope counts" do
    visit "/admin/scopes"

    expect(page).to have_content "All (4)"
    expect(page).to have_content "Published (2)"
    expect(page).to have_content "Block Scope (1)"
    expect(page).to have_content "Proc Scope (1)"
    expect(page).to have_content "Context Variable (1)"
    expect(page).to have_content "Context Boolean (0)"
    expect(page).to have_content "Second Block (0)"
  end

  scenario "View scoped index" do
    visit "/admin/scopes"
    click_link "Published (2)"

    expect(page).to have_content "Displaying all 2 Posts"

    expect(page).to have_content "Published 1"
    expect(page).to have_content "Published 2"

    expect(page).not_to have_content "Unpublished 1"
    expect(page).not_to have_content "Unpublished 2"
  end
end
