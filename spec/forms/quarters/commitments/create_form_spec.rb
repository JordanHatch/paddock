require 'rails_helper'

RSpec.describe Quarters::Commitments::CreateForm do
  describe '.options' do
    it 'returns groups in order' do
      result = mock
      Group.stubs(:in_order).returns(result)

      expect(described_class.options).to eq(result)
    end
  end

  describe '#valid?' do
    let(:group_id) { create(:group).id }
    let(:name) { 'Name' }

    subject do
      described_class.new(Commitment.new).tap { |form| form.validate(group_id: group_id, name: name) }
    end

    context 'with a valid group ID' do
      it 'is true' do
        expect(subject).to be_valid
      end
    end

    context 'with a valid string group ID' do
      let(:group_id) { create(:group).id.to_s }

      it 'is true' do
        expect(subject).to be_valid
      end
    end

    context 'with an invalid group ID' do
      let(:group_id) { 123456 }

      it 'is false' do
        expect(subject).to_not be_valid
      end
    end

    context 'with a missing group ID' do
      let(:group_id) { nil }

      it 'is false' do
        expect(subject).to_not be_valid
      end
    end

    context 'with a missing name' do
      let(:name) { nil }

      it 'is false' do
        expect(subject).to_not be_valid
      end
    end
  end
end
