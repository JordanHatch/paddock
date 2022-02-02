require 'rails_helper'

RSpec.describe 'managing sprint updates', type: :feature, admin_user: true do
  describe 'unpublishing updates' do
    it 'can unpublish a sprint update', js: true do
      update = create(:published_sprint_update)
      sprint = update.sprint
      team = update.team

      visit sprint_path(sprint)
      click_on team.name
      click_on 'Danger zone'
      click_on 'Unpublish'

      visit sprint_path(sprint)
      click_on team.name

      expect(page).to have_content('This update is currently in draft')
    end
  end
end
