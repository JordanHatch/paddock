require 'rails_helper'

RSpec.describe 'editing quarter commitments', type: :feature do
  let!(:quarter) { create(:quarter) }
  let!(:commitment) { create(:commitment, quarter: quarter) }

  def save_and_next
    click_on 'Save and next'
  end

  def find_content_block(title)
    page.find('.update-content-block__title', text: title).ancestor('.update-content-block')
  end

  it 'can edit a commitment', admin_user: true do
    create_list(:team, 3)
    team_1 = create(:team, name: 'Example team 1')
    team_2 = create(:team, name: 'Example team 2')

    visit quarter_path(quarter)

    click_on commitment.name

    click_on 'Edit this page'

    fill_in 'commitment_name', with: 'Commitment name'
    save_and_next

    fill_in 'commitment_overview', with: 'Summary text'
    save_and_next

    within '.sprint-goals' do
      within 'li:nth-of-type(1)' do
        fill_in 'commitment[benefits][]', with: 'Benefit 1'
      end
      within 'li:nth-of-type(2)' do
        fill_in 'commitment[benefits][]', with: 'Benefit 2'
      end
      within 'li:nth-of-type(3)' do
        fill_in 'commitment[benefits][]', with: 'Benefit 3'
      end
    end
    save_and_next

    within '.sprint-goals' do
      within 'li:nth-of-type(1)' do
        fill_in 'commitment[actions][]', with: 'Action 1'
      end
      within 'li:nth-of-type(2)' do
        fill_in 'commitment[actions][]', with: 'Action 2'
      end
      within 'li:nth-of-type(3)' do
        fill_in 'commitment[actions][]', with: 'Action 3'
      end
    end
    save_and_next

    check 'Meat'
    check 'Eggs'
    check 'Fish'
    save_and_next

    select team_1.name, from: 'commitment[team_ids][]'
    select team_2.name, from: 'commitment[team_ids][]'

    click_on 'Save and finish'

    within '.commitment-header' do
      expect(page).to have_content("Commitment #{commitment.number}")
      expect(page).to have_content('Commitment name')
    end

    within '.markdown-block' do
      expect(page).to have_content('Summary text')
    end

    benefits = find_content_block('This will...')
    within benefits do
      expect(page).to have_selector('li', text: 'Benefit 1')
      expect(page).to have_selector('li', text: 'Benefit 2')
      expect(page).to have_selector('li', text: 'Benefit 3')
    end

    actions = find_content_block("So we'll be...")
    within actions do
      expect(page).to have_selector('li', text: 'Action 1')
      expect(page).to have_selector('li', text: 'Action 2')
      expect(page).to have_selector('li', text: 'Action 3')
    end

    actions = find_content_block('Commodities')
    within actions do
      expect(page).to have_selector('li', text: 'Meat')
      expect(page).to have_selector('li', text: 'Eggs')
      expect(page).to have_selector('li', text: 'Fish')
    end
  end
end
