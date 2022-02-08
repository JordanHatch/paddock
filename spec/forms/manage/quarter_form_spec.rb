require 'rails_helper'

RSpec.describe Manage::QuarterForm do
  let(:quarter) { Quarter.new }
  let(:valid_attributes) {
    {
      name: 'Quarter',
      start_on: Date.today,
      end_on: Date.today + 3.months,
      editable: true,
    }
  }
  let(:attributes) { valid_attributes }

  subject do
    described_class.new(quarter).tap {|form| form.deserialize(attributes) }
  end

  describe '#valid?' do
    context 'with valid attributes' do
      it 'is valid' do
        expect(subject).to be_valid
      end
    end

    context 'when name is blank' do
      let(:attributes) { valid_attributes.merge(name: '') }

      it 'is not valid' do
        expect(subject).to_not be_valid
        expect(subject.errors.messages).to have_key(:name)
      end
    end

    context 'when start_on is blank' do
      let(:attributes) { valid_attributes.merge(start_on: '') }

      it 'is not valid' do
        expect(subject).to_not be_valid
        expect(subject.errors.messages).to have_key(:start_on)
      end
    end

    context 'when end_on is blank' do
      let(:attributes) { valid_attributes.merge(end_on: '') }

      it 'is not valid' do
        expect(subject).to_not be_valid
        expect(subject.errors.messages).to have_key(:end_on)
      end
    end

    context 'when start_on is not a date' do
      let(:attributes) { valid_attributes.merge(start_on: 'foo') }

      it 'is not valid' do
        expect(subject).to_not be_valid
        expect(subject.errors.messages).to have_key(:start_on)
      end
    end

    context 'when end_on is not a date' do
      let(:attributes) { valid_attributes.merge(end_on: 'foo') }

      it 'is not valid' do
        expect(subject).to_not be_valid
        expect(subject.errors.messages).to have_key(:end_on)
      end
    end

    context 'when end_on is before start_on' do
      let(:attributes) { valid_attributes.merge(end_on: Date.today - 3.months) }

      it 'is not valid' do
        expect(subject).to_not be_valid
        expect(subject.errors.messages).to have_key(:end_on)
      end
    end
  end
end
