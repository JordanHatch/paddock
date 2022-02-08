require 'rails_helper'

RSpec.describe Manage::SprintForm do
  subject do
    described_class.new(Sprint.new).tap do |form|
      form.validate(params)
    end
  end

  describe '#prepopulate!' do
    subject do
      described_class.new(Sprint.new).tap do |form|
        form.validate(params)
        form.prepopulate!
      end
    end

    context 'when the start and end dates are blank' do
      let(:params) do
        {
          name: 'Sprint X',
          short_label: 'X',
          start_on: nil,
          end_on: nil,
        }
      end

      context 'when the most recent sprint exists' do
        let!(:sprints) do
          create_list(:sprint, 3)
        end

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
        let(:params) do
          {
            name: 'Sprint X',
            short_label: 'X',
            start_on: Date.today,
            end_on: nil,
          }
        end

        it 'retains the existing value' do
          expect(subject.start_on).to eq(params[:start_on])
          expect(subject.end_on).to eq(nil)
        end
      end

      context 'when an end_on value is already present' do
        let(:params) do
          {
            name: 'Sprint X',
            short_label: 'X',
            start_on: nil,
            end_on: Date.today,
          }
        end

        it 'retains the existing value' do
          expect(subject.end_on).to eq(params[:end_on])
        end
      end
    end
  end

  describe '#valid?' do
    let(:valid_params) do
      {
        name: 'Example',
        short_label: '1',
        start_on: Date.today,
        end_on: Date.today + 2.weeks,
      }
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
          expect(subject.errors.messages).to have_key(:name)
        end
      end

      context 'with a blank start_on date' do
        let(:params) do
          valid_params.merge(start_on: nil)
        end

        it 'is not valid' do
          expect(subject).to_not be_valid
          expect(subject.errors.messages).to have_key(:start_on)
        end
      end

      context 'with a blank end_on date' do
        let(:params) do
          valid_params.merge(end_on: nil)
        end

        it 'is not valid' do
          expect(subject).to_not be_valid
          expect(subject.errors.messages).to have_key(:end_on)
        end
      end

      context 'with a blank short_label' do
        let(:params) do
          valid_params.merge(short_label: nil)
        end

        it 'is not valid' do
          expect(subject).to_not be_valid
          expect(subject.errors.messages).to have_key(:short_label)
        end
      end

      context 'with an invalid start_on date' do
        let(:params) do
          valid_params.merge(start_on: 'not a date')
        end

        it 'is not valid' do
          expect(subject).to_not be_valid
          expect(subject.errors.messages).to have_key(:start_on)
        end
      end

      context 'with an invalid end_on date' do
        let(:params) do
          valid_params.merge(end_on: 'not a date')
        end

        it 'is not valid' do
          expect(subject).to_not be_valid
          expect(subject.errors.messages).to have_key(:end_on)
        end
      end

      context 'when end_on is before start_on' do
        let(:params) do
          valid_params.merge(start_on: Date.today + 2.weeks, end_on: Date.today)
        end

        it 'is not valid' do
          expect(subject).to_not be_valid
          expect(subject.errors.messages).to have_key(:end_on)
        end
      end

      context 'when the short_label is longer than 3 characters' do
        let(:params) do
          valid_params.merge(short_label: '1234')
        end

        it 'is not valid' do
          expect(subject).to_not be_valid
          expect(subject.errors.messages).to have_key(:short_label)
        end
      end
    end
  end
end
