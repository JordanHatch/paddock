require 'rails_helper'

RSpec.describe TeamSummary do
  describe '.for_sprint' do
    let(:sprint) { create(:sprint) }

    context 'the team is active for the sprint' do
      let!(:teams) do
        create_list(:team, 3, start_on: sprint.start_on)
      end

      it 'returns the teams for the current sprint' do
        summaries = described_class.for_sprint(sprint)

        expect(summaries.map(&:id)).to contain_exactly(*teams.map(&:id))
      end

      context 'when an update exists for the team and sprint' do
        before(:each) do
          teams.map do |team|
            create_list(:sprint_update, 3, team: team)
          end
        end

        let!(:updates) do
          teams.map do |team|
            create(:sprint_update, team: team, sprint: sprint)
          end
        end

        it 'returns the relevant update fields' do
          summaries = described_class.for_sprint(sprint)

          %i[state delivery_status okr_status].each do |field|
            result = summaries.map(&field)
            expected = updates.map(&field)

            expect(result).to contain_exactly(*expected)
          end

          expect(summaries.map(&:update_id)).to contain_exactly(*updates.map(&:id))
        end

        it 'returns the issue count' do
          updates.each do |update|
            create_list(:issue, 3, sprint_update: update)
          end

          summaries = described_class.for_sprint(sprint)

          expect(summaries.map(&:issue_count)).to contain_exactly(*[3] * 3)
        end
      end

      context 'when no update exists for the team and sprint' do
        it 'returns empty update fields' do
          summaries = described_class.for_sprint(sprint)
          all_nil = teams.map { nil }

          %i[state delivery_status okr_status].each do |field|
            result = summaries.map(&field)
            expect(result).to contain_exactly(*all_nil)
          end

          expect(summaries.map(&:update_id)).to contain_exactly(*all_nil)
        end
      end
    end

    context 'the team starts after the sprint' do
      let!(:teams) do
        create_list(:team, 3, start_on: sprint.end_on + 1.day)
      end

      it 'returns an empty list' do
        summaries = described_class.for_sprint(sprint)
        expect(summaries).to be_empty
      end
    end

    context 'the team has no start_on date' do
      let!(:teams) do
        create_list(:team, 3, start_on: nil)
      end

      it 'returns the teams' do
        summaries = described_class.for_sprint(sprint)

        expect(summaries.map(&:id)).to contain_exactly(*teams.map(&:id))
      end
    end

    context 'the team ends before the sprint' do
      let!(:teams) do
        create_list(:team, 3, end_on: sprint.end_on - 1.day)
      end

      it 'returns an empty list' do
        summaries = described_class.for_sprint(sprint)
        expect(summaries).to be_empty
      end
    end

    context 'the team has no end_on date' do
      let!(:teams) do
        create_list(:team, 3, end_on: nil)
      end

      it 'returns the teams' do
        summaries = described_class.for_sprint(sprint)

        expect(summaries.map(&:id)).to contain_exactly(*teams.map(&:id))
      end
    end
  end

  describe '.with_groups' do
    let(:sprint) { create(:sprint) }
    let!(:groups) { create_list(:group, 3) }
    let!(:teams) do
      groups.map do |group|
        create_list(:team, 3, group: group, start_on: nil)
      end
    end

    it 'returns the teams in groups' do
      expected_teams = teams.map { |teams| teams.map(&:id).sort }

      result = described_class.for_sprint(sprint).with_groups
      result_groups = result.map { |group, _teams| group }
      result_teams = result.map do |_group, teams|
        teams.map(&:id).sort
      end

      expect(result_groups).to contain_exactly(*groups)
      expect(result_teams).to contain_exactly(*expected_teams)
    end

    it 'omits empty groups' do
      # extra group
      extra_group = create(:group)

      result = described_class.for_sprint(sprint).with_groups
      result_groups = result.map { |group, _teams| group }

      expect(result_groups).to_not include(extra_group)
    end
  end

  describe '#to_param' do
    let(:sprint) { create(:sprint) }
    let!(:team) { create(:team, start_on: sprint.start_on) }

    it 'returns the slug for the team' do
      summary = TeamSummary.first

      expect(summary.to_param).to eq(team.slug)
    end
  end
end
