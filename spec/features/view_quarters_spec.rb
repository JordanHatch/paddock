require 'rails_helper'

RSpec.describe 'viewing quarters', type: :feature, admin_user: true do
  def all_commitments
    page.all('.commitments-list__item')
  end

  def commitment_names(elements)
    elements.map do |element|
      element.find('.commitments-list__name').text
    end
  end

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

  describe 'filtering the commitments list' do
    it 'can filter commitments' do
      quarter = create(:quarter)
      meat_commitments = create_list(:commitment, 3, quarter: quarter, commodities: [:meat])
      grain_commitments = create_list(:commitment, 2, quarter: quarter, commodities: [:grain])

      visit quarter_commitments_path(quarter)

      expect(all_commitments.size).to eq(5)

      select 'Meat', from: :commodity
      click_on 'Filter'

      expect(all_commitments.size).to eq(meat_commitments.size)
      expect(commitment_names(all_commitments)).to contain_exactly(*meat_commitments.map(&:name))

      select 'Grain', from: :commodity
      click_on 'Filter'

      expect(all_commitments.size).to eq(grain_commitments.size)
      expect(commitment_names(all_commitments)).to contain_exactly(*grain_commitments.map(&:name))
    end
  end
end
