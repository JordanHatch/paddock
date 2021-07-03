require 'rails_helper'

RSpec.describe 'editing sprint updates', type: :feature do

  let!(:sprint) { create(:sprint) }
  let!(:team) { create(:team) }

  def save_and_next
    click_on 'Save and next'
  end

  it 'can edit a sprint update', js: true do
    visit sprint_path(sprint)

    within '.groups' do
      click_on team.name
    end

    expect(page).to have_content("hasn't been started yet")
    click_on 'Start update'

    within '.update_delivery_status' do
      choose 'Green'
    end
    save_and_next

    within '.update_okr_status' do
      choose 'Amber'
    end
    save_and_next

    within '.update_content' do
      fill_in 'update_content', with: 'Summary text'
    end
    save_and_next

    within '.sprint-goals' do
      within 'li:nth-of-type(1)' do
        fill_in 'update[sprint_goals][]', with: 'Goal 1'
      end
      within 'li:nth-of-type(2)' do
        fill_in 'update[sprint_goals][]', with: 'Goal 2'
      end
      within 'li:nth-of-type(3)' do
        fill_in 'update[sprint_goals][]', with: 'Goal 3'
      end
    end
    save_and_next

    within '.headcount' do
      fill_in 'update_current_headcount', with: '5'
      fill_in 'update_vacant_roles', with: '2'
    end
    save_and_next

    within '.update_team_health' do
      choose '5'
    end
    save_and_next

    # Issues
    within '.issues ol li:nth-of-type(1)' do
      fill_in "What's the issue?", with: 'Example description'
      fill_in "How will we solve it?", with: 'Example treatment'
      fill_in 'What do you need help with?', with: 'Help required'
      fill_in 'If this issue has been raised elsewhere', with: '12345'
    end

    click_on 'Add issue'

    within '.issues ol li:nth-of-type(2)' do
      fill_in "What's the issue?", with: 'A second issue'
      fill_in "How will we solve it?", with: 'Another treatment'
      fill_in 'What do you need help with?', with: 'More help required'
      fill_in 'If this issue has been raised elsewhere', with: '67890'
    end

    save_and_next

    within '.sprint-goals' do
      within 'li:nth-of-type(1)' do
        fill_in 'update[next_sprint_goals][]', with: 'Next goal 1'
      end
      within 'li:nth-of-type(2)' do
        fill_in 'update[next_sprint_goals][]', with: 'Next goal 2'
      end
      within 'li:nth-of-type(3)' do
        fill_in 'update[next_sprint_goals][]', with: 'Next goal 3'
      end
    end

    click_on 'Save and preview'

    expect(page).to have_content('currently in draft')

    delivery_status = page.find('h3', text: 'Delivery status').sibling('.value')
    within delivery_status do
      expect(page).to have_content('Green')
    end

    okr_status = page.find('h3', text: 'OKR progress').sibling('.value')
    within okr_status do
      expect(page).to have_content('Amber')
    end

    team_health = page.find('h3', text: 'Team health').sibling('.value')
    within team_health do
      expect(page).to have_content('5 / 5')
    end

    headcount = page.find('h3', text: 'Headcount').sibling('.value')
    within headcount do
      expect(page).to have_content('5 / 7')
    end

    within '.summary' do
      expect(page).to have_content('Summary text')
    end

    sprint_goals = page.find('h3', text: 'Sprint goals').sibling('ul')
    within sprint_goals do
      expect(page).to have_selector('li', text: 'Goal 1')
      expect(page).to have_selector('li', text: 'Goal 2')
      expect(page).to have_selector('li', text: 'Goal 3')
    end

    issues = page.find('h3', text: 'Issues').sibling('ul')
    within issues do
      within 'li:nth-of-type(1)' do
        expect(page).to have_content('Example description')
        expect(page).to have_content('Example treatment')
        expect(page).to have_content('Help required')
        expect(page).to have_content('12345')
      end

      within 'li:nth-of-type(2)' do
        expect(page).to have_content('A second issue')
        expect(page).to have_content('Another treatment')
        expect(page).to have_content('More help required')
        expect(page).to have_content('67890')
      end
    end

    next_sprint_goals = page.find('h3', text: 'Goals for next sprint').sibling('ul')
    within next_sprint_goals do
      expect(page).to have_selector('li', text: 'Next goal 1')
      expect(page).to have_selector('li', text: 'Next goal 2')
      expect(page).to have_selector('li', text: 'Next goal 3')
    end

    click_on 'Finalise and submit'

    within '.actions' do
      click_on 'Submit update'
    end

    expect(page).to_not have_content('currently in draft')
  end
end
