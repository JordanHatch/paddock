require 'rails_helper'

RSpec.describe 'viewing sprints', type: :feature do

  context 'no sprints exist' do
    it 'shows a placeholder message' do
      visit sprints_path
      expect(page).to have_content('No sprints have been set up yet')
    end
  end

end
