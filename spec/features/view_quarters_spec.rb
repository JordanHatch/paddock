require 'rails_helper'

RSpec.describe 'viewing quarters', type: :feature, admin_user: true do
  context 'no quarters exist' do
    it 'shows a placeholder message' do
      visit quarters_path
      expect(page).to have_content('No quarters have been set up yet')
    end
  end

  describe 'viewing a quarter' do
    it 'lists the key commitments' do
      quarter = create(:quarter)
      commitments = create_list(:key_commitment, 5, quarter: quarter)

      visit quarter_path(quarter)

      expect(page).to have_content(commitments.first.name)
    end
  end
end
