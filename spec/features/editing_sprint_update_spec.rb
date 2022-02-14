require 'rails_helper'

RSpec.describe 'editing sprint updates', type: :feature do
  let!(:sprint) { create(:sprint) }
  let!(:team) { create(:team) }

  def save_and_next
    click_on 'Save and next'
  end

  def find_content_block(title)
    page.find('.update-content-block__title', text: title).ancestor('.update-content-block')
  end

  it 'displays only the teams for the current sprint' do
    current_sprint = create(:sprint, end_on: Date.today)
    included_teams = create_list(:team, 3, start_on: 2.days.ago)
    excluded_teams = create_list(:team, 3, start_on: 2.days.from_now)

    visit sprint_path(current_sprint)

    within '.sprints-update-list' do
      included_teams.each do |team|
        expect(page).to have_content(team.name)
      end

      excluded_teams.each do |team|
        expect(page).to_not have_content(team.name)
      end
    end
  end

  it 'can edit a sprint update', js: true do
    visit sprint_path(sprint)

    within '.sprints-update-list' do
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
      fill_in 'How will we solve it?', with: 'Example treatment'
      fill_in 'What do you need help with?', with: 'Help required'
      fill_in "What's the DevOps issue number?", with: '12345'
    end

    click_on 'Add issue'

    within '.issues ol li:nth-of-type(2)' do
      fill_in "What's the issue?", with: 'A second issue'
      fill_in 'How will we solve it?', with: 'Another treatment'
      fill_in 'What do you need help with?', with: 'More help required'
      fill_in "What's the DevOps issue number?", with: '67890'
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

    indicator_class = '.common__indicator-list__indicator'

    delivery_status = page.find(indicator_class, text: 'Delivery status')
    within delivery_status do
      expect(page).to have_content('Green')
    end

    okr_status = page.find(indicator_class, text: 'OKR progress')
    within okr_status do
      expect(page).to have_content('Amber')
    end

    team_health = page.find(indicator_class, text: 'Team health')
    within team_health do
      expect(page).to have_content('5 / 5')
    end

    headcount = page.find(indicator_class, text: 'Headcount')
    within headcount do
      expect(page).to have_content('5 / 7')
    end

    within '.summary' do
      expect(page).to have_content('Summary text')
    end

    sprint_goals = find_content_block('Sprint goals')
    within sprint_goals do
      expect(page).to have_selector('li', text: 'Goal 1')
      expect(page).to have_selector('li', text: 'Goal 2')
      expect(page).to have_selector('li', text: 'Goal 3')
    end

    issues = find_content_block('2 issues')
    within issues do
      within 'li:nth-of-type(1)' do
        expect(page).to have_content('Example description')
        expect(page).to have_content('Example treatment')
        expect(page).to have_content('Help required')
      end

      within 'li:nth-of-type(2)' do
        expect(page).to have_content('A second issue')
        expect(page).to have_content('Another treatment')
        expect(page).to have_content('More help required')
      end
    end

    next_sprint_goals = find_content_block('Goals for next sprint')
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

  it 'can delete an issue from a sprint update', js: true do
    update = create(:draft_sprint_update)
    create(:issue, sprint_update: update)

    visit edit_update_form_path(update.sprint, update.team, :issues)

    within '.issues ol li:nth-of-type(1)' do
      find('h2').click
      click_on 'Delete issue'
    end
    save_and_next

    update.reload

    expect(update.issues.size).to eq(0)
  end
end
