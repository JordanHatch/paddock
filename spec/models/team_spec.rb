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

  describe '#active_in_sprint?' do
    context 'the start_on date is before the sprint end_on date' do
      let(:sprint) { mock(end_on: Date.today + 2.weeks) }
      let(:team) { build(:team, start_on: Date.today) }

      it 'is true' do
        expect(team.active_in_sprint?(sprint)).to be_truthy
      end
    end

    context 'the start_on date is after the sprint end_on date' do
      let(:sprint) { mock(end_on: Date.today) }
      let(:team) { build(:team, start_on: Date.today + 2.weeks) }

      it 'is false' do
        expect(team.active_in_sprint?(sprint)).to be_falsey
      end
    end

    context 'the start_on date is equal to the sprint end_on date' do
      let(:sprint) { mock(end_on: Date.today) }
      let(:team) { build(:team, start_on: Date.today) }

      it 'is true' do
        expect(team.active_in_sprint?(sprint)).to be_truthy
      end
    end

    context 'the start_on date is empty' do
      let(:sprint) { mock }
      let(:team) { build(:team, start_on: nil) }

      it 'is true' do
        expect(team.active_in_sprint?(sprint)).to be_truthy
      end
    end
  end
end
