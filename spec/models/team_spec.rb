require 'rails_helper'

RSpec.describe Team do
  describe '.for_sprint' do
    let(:sprint_end_date) { Date.parse('2022-06-01') }
    let(:sprint) { create(:sprint, end_on: sprint_end_date) }

    let(:results) { Team.for_sprint(sprint) }

    before(:each) { Timecop.freeze(sprint_end_date) }
    after(:each) { Timecop.return }

    describe 'filtering by start_on date' do
      def create_teams_with_future_start_date
        create_list(:team, 2, start_on: sprint_end_date + 2.weeks)
      end

      before(:each) { create_teams_with_future_start_date }

      it 'returns teams where start_on is prior to the sprint end date' do
        expected = create_list(:team, 2, start_on: sprint_end_date - 2.weeks)

        expect(results).to contain_exactly(*expected)
      end

      it 'returns teams where start_on is equal to the sprint end date' do
        expected = create_list(:team, 2, start_on: sprint_end_date)

        expect(results).to contain_exactly(*expected)
      end

      it 'returns teams where start_on is empty' do
        expected = create_list(:team, 2, start_on: nil)

        expect(results).to contain_exactly(*expected)
      end
    end

    describe 'filtering by end_on date' do
      def create_teams_with_historical_end_date
        create_list(:team, 2, end_on: sprint_end_date - 2.weeks)
      end

      before(:each) { create_teams_with_historical_end_date }

      it 'returns teams where end_on is later than the sprint end date' do
        expected = create_list(:team, 2, end_on: sprint_end_date + 2.weeks)

        expect(results).to contain_exactly(*expected)
      end

      it 'returns teams where end_on is equal to the sprint end date' do
        expected = create_list(:team, 2, end_on: sprint_end_date)

        expect(results).to contain_exactly(*expected)
      end

      it 'returns teams where end_on is empty' do
        expected = create_list(:team, 2, end_on: nil)

        expect(results).to contain_exactly(*expected)
      end
    end

    describe 'filtering by start_on and end_on date' do
      def create_excluded_teams
        create(:team, start_on: sprint_end_date + 2.weeks)
        create(:team, end_on: sprint_end_date - 2.weeks)
      end

      before(:each) { create_excluded_teams }

      it 'returns the teams which start and end in the current sprint' do
        expected = create_list(:team, 2, start_on: sprint_end_date - 2.weeks, end_on: sprint_end_date)

        expect(results).to contain_exactly(*expected)
      end
    end
  end

  describe '#active_in_sprint?' do
    let(:sprint_end_date) { Date.today }
    let(:sprint) { Sprint.new(end_on: sprint_end_date) }

    subject { team.active_in_sprint?(sprint) }

    context 'the start_on date is before the sprint end_on date' do
      let(:team) { build(:team, start_on: sprint_end_date - 2.weeks) }

      it 'is true' do
        expect(subject).to be_truthy
      end
    end

    context 'the start_on date is after the sprint end_on date' do
      let(:team) { build(:team, start_on: sprint_end_date + 2.weeks) }

      it 'is false' do
        expect(subject).to be_falsey
      end
    end

    context 'the start_on date is equal to the sprint end_on date' do
      let(:team) { build(:team, start_on: sprint_end_date) }

      it 'is true' do
        expect(subject).to be_truthy
      end
    end

    context 'the start_on date is empty' do
      let(:team) { build(:team, start_on: nil) }

      it 'is true' do
        expect(subject).to be_truthy
      end
    end

    context 'the end_on date is after the sprint end_on date' do
      let(:team) { build(:team, end_on: sprint_end_date + 2.weeks) }

      it 'is true' do
        expect(subject).to be_truthy
      end
    end

    context 'the end_on date is before the sprint end_on date' do
      let(:team) { build(:team, end_on: sprint_end_date - 2.weeks) }

      it 'is false' do
        expect(subject).to be_falsey
      end
    end

    context 'the end_on date is equal to the sprint end_on date' do
      let(:team) { build(:team, end_on: sprint_end_date) }

      it 'is true' do
        expect(subject).to be_truthy
      end
    end

    context 'the end_on date is empty' do
      let(:team) { build(:team, end_on: nil) }

      it 'is true' do
        expect(subject).to be_truthy
      end
    end

    context 'the start_on and end_on dates are in the current sprint' do
      let(:team) { build(:team, start_on: sprint_end_date - 2.weeks, end_on: sprint_end_date) }

      it 'is true' do
        expect(subject).to be_truthy
      end
    end
  end
end
