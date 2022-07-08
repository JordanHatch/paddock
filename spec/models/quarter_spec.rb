require 'rails_helper'

RSpec.describe Quarter do
  describe '.current' do
    subject { described_class.current }

    context 'when a current quarter exists' do
      before(:each) do
        create(:quarter, start_on: 5.months.ago, end_on: 2.months.ago)
      end

      let!(:current_quarter) do
        create(:quarter, start_on: 1.month.ago, end_on: 2.months.from_now)
      end

      it 'returns the quarter' do
        expect(subject).to eq(current_quarter)
      end
    end

    context 'when other quarters exist that are not current' do
      before(:each) do
        create(:quarter, start_on: 6.months.ago, end_on: 3.months.ago)
        create(:quarter, start_on: 3.months.ago, end_on: 1.day.ago)
      end

      it 'returns nil' do
        expect(subject).to be_nil
      end
    end

    context 'when no quarters exist' do
      it 'returns nil' do
        expect(subject).to be_nil
      end
    end
  end
end
