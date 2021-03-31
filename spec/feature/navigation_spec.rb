require 'spec_helper'

feature 'Navigation' do

  before do
    # NB zeitwerk can eager-load files in arbitrary order
    # https://github.com/fxn/zeitwerk/issues/92#issuecomment-543834270
    #  -- simulating here
    # (also note that manually reloading is required in order for there to be any in sidebar at all)
    %w[PostsAdmin DialogAdmin AutomaticAdmin ScopesAdmin].each do |class_name|
      Object.send(:remove_const, class_name) if Object.const_defined?(class_name)
      load(Rails.root.join("app/admin/#{class_name.underscore}.rb"))
    end
  end

  scenario 'Sidebar lists resources in alphabetic order (not random order)' do
    visit '/admin/scopes'
    got_texts = page.all(".app-sidebar-inner .app-nav ul li").map(&:text)
    expected_texts = %w[Automatic Dialog Posts Scopes]
    expect(got_texts).to contain_exactly(*expected_texts) # <- this is fine
    expect(got_texts).to eq(expected_texts) # <- this is problematic
  end
end
