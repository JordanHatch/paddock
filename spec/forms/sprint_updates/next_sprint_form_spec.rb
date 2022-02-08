require 'rails_helper'

RSpec.describe SprintUpdates::NextSprintForm do
  describe '#prepopulate!' do
    it 'fills up to 5 sprint goals' do
      form = described_class.new(Update.new)
      form.prepopulate!

      expect(form.next_sprint_goals.size).to eq(5)
    end
  end

  describe '#next_sprint_goals=' do
    it 'removes blank sprint goals' do
      form = described_class.new(Update.new)

      form.validate({
        'next_sprint_goals' => [
          'One',
          'Two',
          '',
          '',
          '',
        ]
      })
      output = form.to_nested_hash['next_sprint_goals']

      expect(output).to contain_exactly('One', 'Two')
    end
  end
end
