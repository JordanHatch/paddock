require 'rails_helper'

RSpec.describe Quarters::ReorderKeyCommitments do
  let!(:quarter) { create(:quarter) }
  let!(:commitments) do
    [
      create(:key_commitment, quarter: quarter, number: 1),
      create(:key_commitment, quarter: quarter, number: 2),
      create(:key_commitment, quarter: quarter, number: 3),
    ]
  end
  let(:ids) { commitments.map(&:id) }
  let(:order) do
    {
      ids[0] => 3,
      ids[1] => 1,
      ids[2] => 2,
    }
  end

  subject do
    described_class.run(
      quarter: quarter,
      order: order,
    )
  end

  describe '.run' do
    context 'with valid arguments' do
      it 'reorders commitments' do
        expect(subject).to be_valid

        records = quarter.commitments.order(:id)
        expect(records.map(&:number)).to eq([3, 1, 2])
      end
    end

    context 'with strings of integers' do
      let(:order) do
        {
          ids[0].to_s => '3',
          ids[1].to_s => '1',
          ids[2].to_s => '2',
        }
      end

      it 'reorders commitments' do
        expect(subject).to be_valid

        records = quarter.commitments.order(:id)
        expect(records.map(&:number)).to eq([3, 1, 2])
      end
    end

    context 'with invalid order values' do
      context 'a string' do
        let(:order) { 'foo' }

        it 'is invalid' do
          expect(subject).to_not be_valid
          expect(subject.errors).to have_key(:order)
        end
      end

      context 'an array' do
        let(:order) { [] }

        it 'is invalid' do
          expect(subject).to_not be_valid
          expect(subject.errors).to have_key(:order)
        end
      end

      context 'a non-numeric key' do
        let(:order) { { 'foo' => 1 } }

        it 'is invalid' do
          expect(subject).to_not be_valid
          expect(subject.errors).to have_key(:order)
        end
      end

      context 'a non-numeric value' do
        let(:order) { { 1 => 'foo' } }

        it 'is invalid' do
          expect(subject).to_not be_valid
          expect(subject.errors).to have_key(:order)
        end
      end

      context 'an array value' do
        let(:order) { { 1 => %w[foo bar] } }

        it 'is invalid' do
          expect(subject).to_not be_valid
          expect(subject.errors).to have_key(:order)
        end
      end
    end

    context 'when a commitment does not exist' do
      let(:order) do
        {
          1 => 3,
          4 => 2,
        }
      end

      it 'fails' do
        expect(subject).to_not be_valid
      end
    end

    context 'when a commitment is not a key_commitment' do
      let(:other_commitment) { create(:commitment, quarter: quarter) }
      let(:order) do
        {
          ids[0] => 2,
          other_commitment.id => 1,
        }
      end

      it 'fails' do
        expect(subject).to_not be_valid
      end
    end

    context 'when a commitment cannot be saved' do
      let(:order) do
        {
          1 => 2,
          2 => 3,
        }
      end

      before(:each) do
        Commitment.any_instance.stubs(:save!).raises(ActiveRecord::RecordInvalid)
      end

      it 'is invalid' do
        expect(subject).to be_invalid
      end
    end

    context 'when the quarter is not editable' do
      let(:quarter) { create(:non_editable_quarter) }

      it 'is invalid' do
        expect(subject).to_not be_valid
        expect(subject.errors).to have_key(:quarter)
      end
    end
  end
end
