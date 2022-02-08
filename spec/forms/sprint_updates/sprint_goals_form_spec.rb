require 'rails_helper'

RSpec.describe SprintUpdates::SprintGoalsForm do
  describe '#prepopulate!' do
    it 'fills up to 5 sprint goals' do
      form = described_class.new(Update.new)
      form.prepopulate!

      expect(form.sprint_goals.size).to eq(5)
    end
  end

  describe '#sprint_goals=' do
    it 'removes blank sprint goals' do
      form = described_class.new(Update.new)

      form.validate({
        'sprint_goals' => [
          'One',
          'Two',
          '',
          '',
          '',
        ],
      })
      output = form.to_nested_hash['sprint_goals']

      expect(output).to contain_exactly('One', 'Two')
    end
  end

  describe '#valid?' do
    subject do
      described_class.new(Update.new).tap {|form| form.validate({ sprint_goals: goals }) }
    end

    context 'with one or more goals' do
      let(:goals) { ['Goal 1', 'Goal 2'] }

      it 'is valid' do
        expect(subject).to be_valid
      end
    end

    context 'with an empty array' do
      let(:goals) { [] }

      it 'is invalid' do
        expect(subject).to_not be_valid
        expect(subject.errors.messages).to have_key(:sprint_goals)
      end
    end

    context 'when nil' do
      let(:goals) { nil }

      it 'is invalid' do
        expect(subject).to_not be_valid
        expect(subject.errors.messages).to have_key(:sprint_goals)
      end
    end
  end
end
