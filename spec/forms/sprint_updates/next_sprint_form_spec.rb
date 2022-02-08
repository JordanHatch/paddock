require 'rails_helper'

RSpec.describe SprintUpdates::NextSprintForm do
  describe '#prepopulate!' do
    it 'fills up to 5 sprint goals' do
      form = described_class.new(Update.new)
      form.prepopulate!

      expect(form.next_sprint_goals.size).to eq(5)
    end

    it 'initializes an array when nil' do
      form = described_class.new(Update.new(next_sprint_goals: nil))
      form.prepopulate!

      expect(form.next_sprint_goals.size).to eq(5)
    end
  end

  describe '#next_sprint_goals=' do
    subject do
      described_class.new(Update.new).tap {|form| form.validate({ next_sprint_goals: goals }) }
    end

    context 'with blank sprint goals' do
      let(:goals) { ['One', 'Two', '', '', ''] }

      it 'removes the blank goals' do
        output = subject.to_nested_hash['next_sprint_goals']
        expect(output).to contain_exactly('One', 'Two')
      end
    end

    context 'with 5 sprint goals' do
      let(:goals) { ['One', 'Two', 'Three', 'Four', 'Five'] }

      it 'does not remove any goals' do
        output = subject.to_nested_hash['next_sprint_goals']
        expect(output).to contain_exactly(*goals)
      end
    end
  end

  describe '#valid?' do
    subject do
      described_class.new(Update.new).tap {|form| form.validate({ next_sprint_goals: goals }) }
    end

    context 'with zero goals' do
      let(:goals) { [] }

      it 'is valid' do
        expect(subject).to be_valid
      end
    end

    context 'with one or more goals' do
      let(:goals) { ['Goal 1', 'Goal 2'] }

      it 'is valid' do
        expect(subject).to be_valid
      end
    end

    context 'when nil' do
      let(:goals) { nil }

      it 'is invalid' do
        expect(subject).to_not be_valid
        expect(subject.errors.messages).to have_key(:next_sprint_goals)
      end
    end
  end
end
