require 'rails_helper'

RSpec.describe Commitment, type: :model do

  describe '.key_commitments' do
    it 'returns only objects where key_commitment is true' do
      create(:commitment)
      result = create(:key_commitment)

      expect(described_class.key_commitments).to contain_exactly(result)
    end
  end

  describe '.other_commitments' do
    it 'returns only objects where key_commitment is false' do
      create(:key_commitment)
      result = create(:commitment)

      expect(described_class.other_commitments).to contain_exactly(result)
    end
  end

end
