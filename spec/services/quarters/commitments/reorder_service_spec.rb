require 'rails_helper'

RSpec.describe Quarters::Commitments::ReorderService do
  let!(:quarter) { create(:quarter) }
  let!(:commitments) do
    {
      1 => create(:commitment, quarter: quarter, number: 1),
      2 => create(:commitment, quarter: quarter, number: 2),
      3 => create(:commitment, quarter: quarter, number: 3),
    }
  end

  it 'can reorder commitments' do
    input = {
      1 => 3,
      2 => 1,
      3 => 2,
    }

    service = described_class.call(
      quarter_id: quarter.id,
      order: input,
    )
    expect(service).to be_success

    records = quarter.commitments.order(:id)
    expect(records.map(&:number)).to eq([3, 1, 2])
  end

  it 'accepts form input as strings of integers' do
    input = {
      '1' => '3',
      '2' => '1',
      '3' => '2',
    }

    service = described_class.call(
      quarter_id: quarter.id,
      order: input,
    )
    expect(service).to be_success

    records = quarter.commitments.order(:id)
    expect(records.map(&:number)).to eq([3, 1, 2])
  end

  it 'fails when not provided valid input' do
    examples = [
      'foo',
      [],
      { 'foo' => 1 },
      { 1 => 'bar' },
    ]

    examples.each do |value|
      service = described_class.call(
        quarter_id: quarter.id,
        order: value,
      )
      expect(service).to be_failure
      expect(service.result.failure).to eq(:invalid_parameters)
    end
  end

  it 'fails when a commitment does not exist' do
    input = {
      1 => 3,
      4 => 2,
    }

    service = described_class.call(
      quarter_id: quarter.id,
      order: input,
    )
    expect(service).to be_failure
    expect(service.result.failure).to eq(:invalid_commitment)
  end

  it 'fails when a commitment cannot be saved' do
    Commitment.any_instance.stubs(:save).returns(false)

    input = {
      1 => 2,
    }

    service = described_class.call(
      quarter_id: quarter.id,
      order: input,
    )
    expect(service).to be_failure
    expect(service.result.failure).to eq(:save_failed)
  end
end
