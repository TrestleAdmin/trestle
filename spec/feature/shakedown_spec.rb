require 'spec_helper'

feature 'Shakedown', type: :system do
  scenario 'Admin index' do
    visit '/admin'
  end
end
