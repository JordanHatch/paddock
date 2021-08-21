require 'rails_helper'

RSpec.describe 'viewing sprints', type: :feature do
  context 'no sprints exist' do
    it 'shows a placeholder message' do
      visit sprints_path
      expect(page).to have_content('No sprints have been set up yet')
    end
  end

  describe 'the issues list' do
    it 'displays the issues across the sprint updates' do
      sprint = create(:sprint)

      updates = create_list(:published_sprint_update, 3, sprint: sprint)
      issues = updates.map { |upd| create_list(:issue, 2, sprint_update: upd) }.flatten

      visit sprint_issues_path(sprint)

      issues.each do |issue|
        table_row = page.find('td', text: issue.description).ancestor('tr')

        within table_row do
          expect(page).to have_content(issue.team.name)
          expect(page).to have_content(issue.treatment)
          expect(page).to have_content(issue.help)
        end
      end
    end

    it 'does not display issues from draft sprint updates' do
      sprint = create(:sprint)

      updates = create_list(:draft_sprint_update, 3, sprint: sprint)
      updates.each do |upd|
        create_list(:issue, 2, sprint_update: upd)
      end

      visit sprint_issues_path(sprint)

      expect(page).to have_content('No issues')
    end
  end
end
