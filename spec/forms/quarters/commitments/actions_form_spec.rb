require 'rails_helper'

RSpec.describe Quarters::Commitments::ActionsForm do
  describe '#prepopulate!' do
    it 'creates up to 5 empty actions' do
      form = described_class.new(Commitment.new)
      form.prepopulate!

      expect(form.actions.size).to eq(5)
    end
  end

  describe '#actions=' do
    it 'removes blank actions' do
      form = described_class.new(Commitment.new)

      form.validate({
        'actions' => [
          'One',
          'Two',
          '',
          '',
          '',
        ]
      })
      output = form.to_nested_hash['actions']

      expect(output).to contain_exactly('One', 'Two')
    end
  end
end
