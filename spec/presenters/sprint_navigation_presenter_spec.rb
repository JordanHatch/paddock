require 'rails_helper'

RSpec.describe SprintNavigationPresenter do
  let(:sprint) { build(:sprint) }
  let(:team) { build(:team) }
  let(:context) { mock('view context') }

  subject { described_class.new(context, sprint: sprint, team: team) }

  describe '#next_sprint' do
    it 'returns the next sprint' do
      mock_sprint = mock
      sprint.expects(:next_sprint).returns(mock_sprint)

      expect(subject.next_sprint).to eq(mock_sprint)
    end
  end

  describe '#previous_sprint' do
    it 'returns the previous sprint' do
      mock_sprint = mock
      sprint.expects(:previous_sprint).returns(mock_sprint)

      expect(subject.previous_sprint).to eq(mock_sprint)
    end
  end

  describe '#link_to_previous_sprint?' do
    context 'no team is present' do
      let(:team) { nil }

      context 'the previous sprint exists' do
        before(:each) do
          mock_sprint = mock
          sprint.stubs(:previous_sprint).returns(mock_sprint)
        end

        it 'returns true' do
          expect(subject.link_to_previous_sprint?).to be_truthy
        end
      end

      context 'the previous sprint does not exist' do
        before(:each) do
          sprint.stubs(:previous_sprint).returns(nil)
        end

        it 'returns false' do
          expect(subject.link_to_previous_sprint?).to be_falsey
        end
      end
    end

    context 'a team is present' do
      context 'the previous sprint exists' do
        let(:mock_sprint) { mock }

        before(:each) do
          sprint.stubs(:previous_sprint).returns(mock_sprint)
        end

        context 'the team is active in the previous sprint' do
          before(:each) do
            team.stubs(:active_in_sprint?).with(mock_sprint).returns(true)
          end

          it 'returns true' do
            expect(subject.link_to_previous_sprint?).to be_truthy
          end
        end

        context 'the team is not active in the previous sprint' do
          before(:each) do
            team.stubs(:active_in_sprint?).with(mock_sprint).returns(false)
          end

          it 'returns true' do
            expect(subject.link_to_previous_sprint?).to be_falsey
          end
        end
      end

      context 'the previous sprint does not exist' do
        before(:each) do
          sprint.stubs(:previous_sprint).returns(nil)
        end

        it 'returns false' do
          expect(subject.link_to_previous_sprint?).to be_falsey
        end
      end
    end
  end

  describe '#link_to_next_sprint?' do
    context 'no team is present' do
      let(:team) { nil }

      context 'the next sprint exists' do
        before(:each) do
          mock_sprint = mock
          sprint.stubs(:next_sprint).returns(mock_sprint)
        end

        it 'returns true' do
          expect(subject.link_to_next_sprint?).to be_truthy
        end
      end

      context 'the next sprint does not exist' do
        before(:each) do
          sprint.stubs(:next_sprint).returns(nil)
        end

        it 'returns false' do
          expect(subject.link_to_next_sprint?).to be_falsey
        end
      end
    end

    context 'a team is present' do
      context 'the next sprint exists' do
        let(:mock_sprint) { mock }

        before(:each) do
          sprint.stubs(:next_sprint).returns(mock_sprint)
        end

        context 'the team is active in the next sprint' do
          before(:each) do
            team.stubs(:active_in_sprint?).with(mock_sprint).returns(true)
          end

          it 'returns true' do
            expect(subject.link_to_next_sprint?).to be_truthy
          end
        end

        context 'the team is not active in the next sprint' do
          before(:each) do
            team.stubs(:active_in_sprint?).with(mock_sprint).returns(false)
          end

          it 'returns true' do
            expect(subject.link_to_next_sprint?).to be_falsey
          end
        end
      end

      context 'the next sprint does not exist' do
        before(:each) do
          sprint.stubs(:next_sprint).returns(nil)
        end

        it 'returns false' do
          expect(subject.link_to_next_sprint?).to be_falsey
        end
      end
    end
  end
end
