require 'rails_helper'

RSpec.describe QuarterNavigationPresenter do
  let(:quarter) { build(:quarter) }
  let(:context) { mock('view context') }

  subject { described_class.new(context, quarter: quarter) }

  describe '#next_quarter' do
    it 'returns the next quarter' do
      mock_quarter = mock
      quarter.expects(:next_quarter).returns(mock_quarter)

      expect(subject.next_quarter).to eq(mock_quarter)
    end
  end

  describe '#previous_quarter' do
    it 'returns the previous quarter' do
      mock_quarter = mock
      quarter.expects(:previous_quarter).returns(mock_quarter)

      expect(subject.previous_quarter).to eq(mock_quarter)
    end
  end

  describe '#link_to_previous_quarter?' do
    context 'the previous quarter exists' do
      before(:each) do
        mock_quarter = mock
        quarter.stubs(:previous_quarter).returns(mock_quarter)
      end

      it 'returns true' do
        expect(subject.link_to_previous_quarter?).to be_truthy
      end
    end

    context 'the previous quarter does not exist' do
      before(:each) do
        quarter.stubs(:previous_quarter).returns(nil)
      end

      it 'returns false' do
        expect(subject.link_to_previous_quarter?).to be_falsey
      end
    end
  end

  describe '#link_to_next_quarter?' do
    context 'the next quarter exists' do
      before(:each) do
        mock_quarter = mock
        quarter.stubs(:next_quarter).returns(mock_quarter)
      end

      it 'returns true' do
        expect(subject.link_to_next_quarter?).to be_truthy
      end
    end

    context 'the next quarter does not exist' do
      before(:each) do
        quarter.stubs(:next_quarter).returns(nil)
      end

      it 'returns false' do
        expect(subject.link_to_next_quarter?).to be_falsey
      end
    end
  end
end
