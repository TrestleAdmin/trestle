require 'spec_helper'

feature 'Shakedown' do
  scenario 'Admin index' do
    visit '/admin'
  end
end
