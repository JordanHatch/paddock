require 'rails_helper'

RSpec.describe Manage::SprintForm do

  describe 'on initialize' do
    context 'when the start and end dates are blank' do
      let(:params) {
        {
          name: 'Sprint X',
          start_on: nil,
          end_on: nil,
        }
      }

      subject { described_class.from_form(params) }

      context 'when the most recent sprint exists' do
        let!(:sprints) {
          create_list(:sprint, 3)
        }

        it 'sets the start date to the day after the last sprint' do
          expected_date = sprints.last.end_on + 1.day
          expect(subject.start_on).to eq(expected_date)
        end

        it 'sets the end date to 13 days after the start date' do
          expected_date = sprints.last.end_on + 1.day + 13.days
          expect(subject.end_on).to eq(expected_date)
        end
      end

      context 'when no recent sprint exists' do
        it 'remains nil' do
          expect(subject.start_on).to eq(nil)
          expect(subject.end_on).to eq(nil)
        end
      end

      context 'when a start_on value is already present' do
        let(:params) {
          {
            name: 'Sprint X',
            start_on: Date.today,
            end_on: nil,
          }
        }

        it 'retains the existing value' do
          expect(subject.start_on).to eq(params[:start_on])
          expect(subject.end_on).to eq(nil)
        end
      end

      context 'when an end_on value is already present' do
        let(:params) {
          {
            name: 'Sprint X',
            start_on: nil,
            end_on: Date.today,
          }
        }

        it 'retains the existing value' do
          expect(subject.end_on).to eq(params[:end_on])
        end
      end
    end
  end

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
