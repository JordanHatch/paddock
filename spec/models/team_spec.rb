require 'rails_helper'

RSpec.describe Team do

  describe '.for_sprint' do
    it 'returns the teams with a start_on value before the current sprint end date' do
      sprint = create(:sprint, end_on: Date.parse('2021-02-01'))

      included_teams = create_list(:team, 3, start_on: Date.parse('2021-01-30'))
      excluded_teams = create_list(:team, 3, start_on: Date.parse('2021-02-05'))

      expect(Team.for_sprint(sprint)).to contain_exactly(*included_teams)
    end

    it 'returns teams with a start_on value equal to the current sprint end date' do
      sprint = create(:sprint, end_on: Date.parse('2021-02-01'))

      included_teams = create_list(:team, 3, start_on: Date.parse('2021-02-01'))
      excluded_teams = create_list(:team, 3, start_on: Date.parse('2021-02-05'))

      expect(Team.for_sprint(sprint)).to contain_exactly(*included_teams)
    end

    it 'returns teams where start_on is empty' do
      sprint = create(:sprint, end_on: Date.parse('2021-02-01'))

      included_teams = create_list(:team, 3, start_on: nil)
      excluded_teams = create_list(:team, 3, start_on: Date.parse('2021-02-05'))

      expect(Team.for_sprint(sprint)).to contain_exactly(*included_teams)
    end
  end
end
