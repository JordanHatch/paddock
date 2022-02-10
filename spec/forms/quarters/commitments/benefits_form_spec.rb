require 'rails_helper'

RSpec.describe Quarters::Commitments::BenefitsForm do
  describe '#prepopulate!' do
    it 'creates up to 5 empty benefits' do
      form = described_class.new(Commitment.new)
      form.prepopulate!

      expect(form.benefits.size).to eq(5)
    end

    it 'initializes an array when nil' do
      form = described_class.new(Commitment.new(benefits: nil))
      form.prepopulate!

      expect(form.benefits.size).to eq(5)
    end
  end

  describe '#benefits=' do
    subject do
      described_class.new(Commitment.new).tap { |form| form.validate({ benefits: benefits }) }
    end

    context 'with blank benefits' do
      let(:benefits) { ['One', 'Two', '', '', ''] }

      it 'removes the blank goals' do
        output = subject.to_nested_hash['benefits']
        expect(output).to contain_exactly('One', 'Two')
      end
    end

    context 'when nil' do
      let(:benefits) { nil }

      it 'sets an empty array' do
        output = subject.to_nested_hash['benefits']
        expect(output).to eq([])
      end
    end

    context 'with 5 benefits' do
      let(:benefits) { %w[One Two Three Four Five] }

      it 'does not remove any benefits' do
        output = subject.to_nested_hash['benefits']
        expect(output).to contain_exactly(*benefits)
      end
    end
  end
end
