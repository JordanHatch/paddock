require 'rails_helper'

RSpec.describe Sprint do
  describe '.teams' do
    it 'returns the teams with a start_on value before the current sprint end date' do
      sprint = create(:sprint, end_on: Date.parse('2021-02-01'))

      included_teams = create_list(:team, 3, start_on: Date.parse('2021-01-30'))
      excluded_teams = create_list(:team, 3, start_on: Date.parse('2021-02-05'))

      expect(sprint.teams).to contain_exactly(*included_teams)
    end
  end
end
