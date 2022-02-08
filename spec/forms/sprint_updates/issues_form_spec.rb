require 'rails_helper'

RSpec.describe SprintUpdates::IssuesForm do
  let(:params) { {} }
  let(:update) { Update.new }

  subject do
    described_class.new(update).tap { |form| form.validate(params) }
  end

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
        expect(subject).to be_valid
      end
    end

    context 'when empty' do
      let(:params) do
        {
          'issues_attributes' => {},
        }
      end

      it 'is valid' do
        expect(subject).to be_valid
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
          expect(subject).to_not be_valid

          errors = subject.issues[0].errors.messages
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
          expect(subject).to_not be_valid

          errors = subject.issues[0].errors.messages
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
          expect(subject).to_not be_valid

          errors = subject.issues[1].errors.messages
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
        expect(subject).to_not be_started
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
        expect(subject).to be_started
      end
    end
  end

  describe '#populate_issues!' do
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
        output = subject.to_nested_hash

        expect(output['issues'].size).to eq(0)
        expect(subject.issues.size).to eq(0)
      end
    end
  end

  describe '#prepopulate!' do
    before(:each) do
      subject.prepopulate!
    end

    context 'when no issues exist' do
      it 'creates a first issue' do
        expect(subject.issues.size).to eq(1)
      end
    end

    context 'when an issue already exists' do
      let(:update) do
        Update.new(
          issues: [Issue.new],
        )
      end

      it 'does not create a new issue' do
        expect(subject.issues.size).to eq(1)
      end
    end
  end
end
