require 'rails_helper'

RSpec.describe Quarters::Commitments::BenefitsForm do
  describe '#prepopulate!' do
    it 'creates up to 5 empty benefits' do
      form = described_class.new(Commitment.new)
      form.prepopulate!

      expect(form.benefits.size).to eq(5)
    end
  end

  describe '#benefits=' do
    it 'removes blank benefits' do
      form = described_class.new(Commitment.new)

      form.validate({
        'benefits' => [
          'One',
          'Two',
          '',
          '',
          '',
        ],
      })
      output = form.to_nested_hash['benefits']

      expect(output).to contain_exactly('One', 'Two')
    end
  end
end
