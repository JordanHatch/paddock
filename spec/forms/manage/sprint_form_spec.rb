require 'rails_helper'

RSpec.describe Manage::SprintForm do

  describe '#valid?' do
    let(:valid_params) {
      {
        name: 'Example',
        start_on: Date.today,
        end_on: Date.today + 2.weeks,
      }
    }

    subject {
      described_class.from_form(params)
    }

    context 'when given valid data' do
      let(:params) { valid_params }

      it 'is valid' do
        expect(subject).to be_valid
      end
    end

    context 'when given invalid data' do
      context 'with a blank name' do
        let(:params) {
          valid_params.merge(name: nil)
        }

        it 'is not valid' do
          expect(subject).to_not be_valid
          expect(subject.errors).to have_key(:name)
        end
      end

      context 'with a blank start_on date' do
        let(:params) {
          valid_params.merge(start_on: nil)
        }

        it 'is not valid' do
          expect(subject).to_not be_valid
          expect(subject.errors).to have_key(:start_on)
        end
      end

      context 'with a blank end_on date' do
        let(:params) {
          valid_params.merge(end_on: nil)
        }

        it 'is not valid' do
          expect(subject).to_not be_valid
          expect(subject.errors).to have_key(:end_on)
        end
      end

      context 'with an invalid start_on date' do
        let(:params) {
          valid_params.merge(start_on: 'not a date')
        }

        it 'is not valid' do
          expect(subject).to_not be_valid
          expect(subject.errors).to have_key(:start_on)
        end
      end

      context 'with an invalid end_on date' do
        let(:params) {
          valid_params.merge(end_on: 'not a date')
        }

        it 'is not valid' do
          expect(subject).to_not be_valid
          expect(subject.errors).to have_key(:end_on)
        end
      end

      context 'when end_on is before start_on' do
        let(:params) {
          valid_params.merge(start_on: Date.today + 2.weeks, end_on: Date.today)
        }

        it 'is not valid' do
          expect(subject).to_not be_valid
          expect(subject.errors).to have_key(:end_on)
        end
      end
    end
  end

end
