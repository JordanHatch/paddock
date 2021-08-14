require 'rails_helper'

RSpec.describe 'managing sprints', type: :feature, admin_user: true do
  describe 'editing sprints' do
    it 'can edit an existing sprint' do
      sprint = create(:sprint)
      visit manage_sprints_path

      within '.all-sprints' do
        sprint_el = page.find('.sprint-name', text: sprint.name).ancestor('.sprint')

        within sprint_el do
          click_on 'Edit'
        end
      end

      new_value = 'A new sprint name'

      fill_in 'Sprint name', with: new_value
      click_on 'Save'

      expect(page).to have_content(new_value)
    end
  end

  it 'can add a new sprint' do
    sprint = build(:sprint)
    visit manage_sprints_path

    click_on 'Add a new sprint'

    fill_in 'Sprint name', with: sprint.name

    select sprint.start_on.year, from: 'sprint[start_on(1i)]'
    select sprint.start_on.strftime('%B'), from: 'sprint[start_on(2i)]'
    select sprint.start_on.day, from: 'sprint[start_on(3i)]'

    select sprint.end_on.year, from: 'sprint[end_on(1i)]'
    select sprint.end_on.strftime('%B'), from: 'sprint[end_on(2i)]'
    select sprint.end_on.day, from: 'sprint[end_on(3i)]'

    click_on 'Save'

    within '.all-sprints' do
      expect(page).to have_content(sprint.name)
    end
  end
end
