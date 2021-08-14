require 'rails_helper'

RSpec.describe 'managing teams', type: :feature, admin_user: true do
  it 'can create a new team' do
    group = create(:group)
    team = build(:team)

    visit manage_teams_path

    group_el = page.find('h3', text: group.name).ancestor('.group')
    within group_el do
      click_on 'Add a new team'
    end

    fill_in 'Team name', with: team.name
    click_on 'Save'

    group_el = page.find('h3', text: group.name).ancestor('.group')
    within group_el do
      expect(page).to have_content(team.name)
    end
  end

  it 'can edit an existing team' do
    team = create(:team)
    visit manage_teams_path

    group_el = page.find('h3', text: team.group.name).ancestor('.group')

    within group_el do
      team_el = page.find('.team-name', text: team.name).ancestor('.team')

      within team_el do
        click_on 'Edit'
      end
    end

    new_value = 'A new team name'

    fill_in 'Team name', with: new_value
    click_on 'Save'

    expect(page).to have_content(new_value)
  end
end
