require 'rails_helper'

RSpec.describe SprintUpdates::IssuesForm do
  let(:klass) { subject.class }

  describe '#valid?' do
    context 'when given valid data' do
      let(:params) do
        {
          'issues_attributes' => {
            '1' => {
              'description' => 'Issue description',
              'help' => 'Help wanted',
            },
          },
        }
      end

      it 'is valid' do
        form = klass.from_form(params)
        expect(form).to be_valid
      end
    end

    context 'when empty' do
      let(:params) do
        {
          'issues_attributes' => {},
        }
      end

      it 'is valid' do
        form = klass.from_form(params)
        expect(form).to be_valid
      end
    end

    context 'when given invalid data' do
      context 'with a missing description' do
        let(:params) do
          {
            'issues_attributes' => {
              '1' => {
                'description' => '',
                'help' => 'Help wanted',
              },
            },
          }
        end

        it 'is not valid' do
          form = klass.from_form(params)
          expect(form).to_not be_valid

          errors = form.errors[:issues_attributes][0]
          expect(errors).to have_key(:description)
        end
      end

      context 'with a non-numeric identifier' do
        let(:params) do
          {
            'issues_attributes' => {
              '1' => {
                'description' => 'Example',
                'identifier' => 'abcdefg',
                'help' => 'Help wanted',
              },
            },
          }
        end

        it 'is not valid' do
          form = klass.from_form(params)
          expect(form).to_not be_valid

          errors = form.errors[:issues_attributes][0]
          expect(errors).to have_key(:identifier)
        end
      end

      context 'with one valid and one invalid issue' do
        let(:params) do
          {
            'issues_attributes' => {
              '1' => {
                'description' => 'Valid description',
                'help' => 'Help wanted',
              },
              '2' => {
                'description' => '',
                'help' => 'Help wanted',
              },
            },
          }
        end

        it 'is not valid' do
          form = klass.from_form(params)
          expect(form).to_not be_valid

          errors = form.errors[:issues_attributes][1]
          expect(errors).to have_key(:description)
        end
      end
    end
  end

  describe '#started?' do
    context 'when empty' do
      let(:params) do
        {
          'issues_attributes' => {},
        }
      end

      it 'is false' do
        form = klass.from_form(params)
        expect(form).to_not be_started
      end
    end

    context 'when not empty' do
      let(:params) do
        {
          'issues_attributes' => {
            '1' => {
              'description' => 'Valid description',
              'help' => 'Help wanted',
            },
          },
        }
      end

      it 'is true' do
        form = klass.from_form(params)
        expect(form).to be_started
      end
    end
  end

  describe 'callback:before_validate' do
    context 'with all blank issues' do
      let(:params) do
        {
          'issues_attributes' => {
            '0' => {
              'description' => '',
              'help' => '',
            },
            '1' => {
              'description' => '',
              'help' => '',
            },
          },
        }
      end

      it 'removes the issues' do
        form = klass.from_form(params)
        output = form.to_model_hash

        expect(output[:issues_attributes].size).to eq(0)
        expect(form.issues_attributes.size).to eq(0)
      end
    end
  end
end
