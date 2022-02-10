require 'rails_helper'

RSpec.describe Quarters::Commitments::ActionsForm do
  describe '#prepopulate!' do
    it 'creates up to 5 empty actions' do
      form = described_class.new(Commitment.new)
      form.prepopulate!

      expect(form.actions.size).to eq(5)
    end

    it 'initializes an array when nil' do
      form = described_class.new(Commitment.new(actions: nil))
      form.prepopulate!

      expect(form.actions.size).to eq(5)
    end
  end

  describe '#actions=' do
    subject do
      described_class.new(Commitment.new).tap { |form| form.validate({ actions: actions }) }
    end

    context 'with blank actions' do
      let(:actions) { ['One', 'Two', '', '', ''] }

      it 'removes the blank goals' do
        output = subject.to_nested_hash['actions']
        expect(output).to contain_exactly('One', 'Two')
      end
    end

    context 'when nil' do
      let(:actions) { nil }

      it 'sets an empty array' do
        output = subject.to_nested_hash['actions']
        expect(output).to eq([])
      end
    end

    context 'with 5 actions' do
      let(:actions) { %w[One Two Three Four Five] }

      it 'does not remove any actions' do
        output = subject.to_nested_hash['actions']
        expect(output).to contain_exactly(*actions)
      end
    end
  end
end
