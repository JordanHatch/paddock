require 'rails_helper'

RSpec.describe Manage::TeamForm do
  describe '#valid?' do
    let(:group) { create(:group) }
    let(:valid_params) do
      {
        name: 'Team Name',
        group_id: group.id,
        start_on: Date.today,
      }
    end

    subject do
      described_class.from_form(params)
    end

    context 'when given valid data' do
      let(:params) { valid_params }

      it 'is valid' do
        expect(subject).to be_valid
      end
    end

    context 'when given invalid data' do
      context 'with a blank name' do
        let(:params) do
          valid_params.merge(name: nil)
        end

        it 'is not valid' do
          expect(subject).to_not be_valid
          expect(subject.errors).to have_key(:name)
        end
      end

      context 'with a blank group_id' do
        let(:params) do
          valid_params.merge(group_id: nil)
        end

        it 'is not valid' do
          expect(subject).to_not be_valid
          expect(subject.errors).to have_key(:group_id)
        end
      end

      context 'with a group_id that does not exist' do
        let(:params) do
          valid_params.merge(group_id: 9999999)
        end

        it 'is not valid' do
          expect(subject).to_not be_valid
          expect(subject.errors).to have_key(:group_id)
        end
      end
    end
  end
end
