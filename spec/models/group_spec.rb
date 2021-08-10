require 'rails_helper'

RSpec.describe Group do

  describe '#teams_for_sprint' do
    let(:sprint) { create(:sprint, end_on: Date.parse('2021-02-01')) }
    let(:group) { create(:group) }

    it 'returns the teams with a start_on value before the current sprint' do
      included_teams = create_list(:team, 2, group: group, start_on: Date.parse('2021-01-30'))
      excluded_teams = create_list(:team, 2, group: group, start_on: Date.parse('2021-02-05'))

      expect(group.teams_for_sprint(sprint)).to contain_exactly(*included_teams)
    end
  end

end
