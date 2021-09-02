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

      updates = create_list(:published_sprint_update, 2, sprint: sprint)
      issues = updates.map { |upd| create_list(:issue, 2, sprint_update: upd) }.flatten

      visit sprint_issues_path(sprint)

      expect(page).to have_content('4 issues')

      issues.each do |issue|
        issue_el = page.find('.issue__description', text: issue.description).ancestor('.issue')

        within issue_el do
          expect(page).to have_content(issue.team.name)
          expect(page).to have_content(issue.treatment)
          expect(page).to have_content(issue.help)
        end
      end
    end

    it 'does not display issues from draft sprint updates' do
      sprint = create(:sprint)

      updates = create_list(:draft_sprint_update, 2, sprint: sprint)
      updates.each do |upd|
        create_list(:issue, 2, sprint_update: upd)
      end

      visit sprint_issues_path(sprint)

      expect(page).to have_content('0 issues')
    end

    it 'can filter issues by group' do
      sprint = create(:sprint)
      group = create(:group)
      team = create(:team, group: group)

      update = create(:published_sprint_update, team: team, sprint: sprint)
      issues = create_list(:issue, 2, sprint_update: update)

      # excluded issues
      excl_team = create(:team)
      excl_update = create(:published_sprint_update, team: excl_team, sprint: sprint)
      create_list(:issue, 2, sprint_update: excl_update)

      visit sprint_issues_path(sprint)

      expect(page).to have_content('4 issues')

      within '.filterable-list__filters' do
        check group.name
        click_on 'Apply filters'
      end

      expect(page).to have_content('2 issues')

      issues.each do |issue|
        issue_el = page.find('.issue__description', text: issue.description).ancestor('.issue')

        within issue_el do
          expect(page).to have_content(issue.team.name)
          expect(page).to have_content(issue.treatment)
          expect(page).to have_content(issue.help)
        end
      end
    end
  end
end
