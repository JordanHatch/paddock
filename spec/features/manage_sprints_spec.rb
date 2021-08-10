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

end
