require 'rails_helper'

RSpec.describe 'editing quarter commitments', type: :feature do
  let!(:quarter) { create(:quarter) }
  let!(:commitment) { create(:key_commitment, quarter: quarter) }

  def save_and_next
    click_on 'Save and next'
  end

  def find_content_block(title)
    page.find('.update-content-block__title', text: title).ancestor('.update-content-block')
  end

  it 'can add a new commitment', js: true do
    group = create(:group, name: 'Example group')
    name = 'Commitment name'

    visit quarter_path(quarter)
    click_on 'Commitments'

    group_block = find_content_block(group.name)
    within group_block do
      click_on 'Add commitment'
    end

    fill_in 'commitment_name', with: name
    click_button 'Add commitment'

    expect(page).to have_content("What's this commitment about?")

    visit quarter_commitments_path(quarter)

    group_block = find_content_block(group.name)
    within group_block do
      expect(page).to have_link(name)
    end
  end

  it 'can edit a commitment', admin_user: true do
    create_list(:team, 3)
    team_1 = create(:team, name: 'Example team 1')
    team_2 = create(:team, name: 'Example team 2')
    group = create(:group, name: 'Example group')

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

    select group.name, from: 'commitment[group_id]'
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

    actions = find_content_block('Teams')
    within actions do
      expect(page).to have_selector('li', text: team_1.name)
      expect(page).to have_selector('li', text: team_2.name)
    end
  end

  context 'when the quarter cannot be edited' do
    let!(:quarter) { create(:non_editable_quarter) }

    it 'redirects with an error message' do
      error_message = I18n.t('quarters.alerts.not_editable')
      visit new_quarter_commitment_path(quarter)

      expect(page).to have_content(error_message)
    end
  end
end
