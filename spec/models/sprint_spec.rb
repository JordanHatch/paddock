require 'rails_helper'

RSpec.describe Sprint do
  describe '#teams' do
    it 'returns the teams with a start_on value before the current sprint end date' do
      sprint = create(:sprint, end_on: Date.parse('2021-02-01'))

      included_teams = create_list(:team, 3, start_on: Date.parse('2021-01-30'))

      # excluded teams
      create_list(:team, 3, start_on: Date.parse('2021-02-05'))

      expect(sprint.teams).to contain_exactly(*included_teams)
    end
  end

  describe '.for_quarter' do
    let(:quarter_start_date) { Date.parse('2022-07-01') }
    let(:quarter_end_date) { Date.parse('2022-09-30') }
    let(:quarter) { create(:quarter, start_on: quarter_start_date, end_on: quarter_end_date) }

    it 'returns the sprints for a given quarter' do
      included_sprints = [
        create(:sprint, start_on: Date.parse('2022-06-22'), end_on: Date.parse('2022-07-05')),
        create(:sprint, start_on: Date.parse('2022-07-06'), end_on: Date.parse('2022-07-19')),
        create(:sprint, start_on: Date.parse('2022-07-20'), end_on: Date.parse('2022-08-02')),
        create(:sprint, start_on: Date.parse('2022-08-03'), end_on: Date.parse('2022-08-16')),
        create(:sprint, start_on: Date.parse('2022-08-17'), end_on: Date.parse('2022-08-30')),
        create(:sprint, start_on: Date.parse('2022-08-31'), end_on: Date.parse('2022-09-13')),
        create(:sprint, start_on: Date.parse('2022-09-14'), end_on: Date.parse('2022-09-27')),
        create(:sprint, start_on: Date.parse('2022-09-28'), end_on: Date.parse('2022-10-11')),
      ]

      # excluded sprints
      create(:sprint, start_on: Date.parse('2022-06-08'), end_on: Date.parse('2022-06-21'))
      create(:sprint, start_on: Date.parse('2022-10-12'), end_on: Date.parse('2022-10-25'))

      results = Sprint.for_quarter(quarter)

      expect(results).to contain_exactly(*included_sprints)
    end
  end
end
