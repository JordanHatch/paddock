require 'rails_helper'

RSpec.describe Sprints::UpdateSprintUpdate do
  let(:update) { create(:draft_sprint_update) }
  let(:form_class) { SprintUpdates::DeliveryStatusForm }
  let(:exception) { Sprints::UpdateSprintUpdate::RequiredArgumentMissing }

  describe '.new' do
    subject do
      described_class.new(
        update: update,
        form_class: form_class,
      )
    end

    context 'with valid params' do
      it 'is valid' do
        expect(subject).to be_valid
      end

      it 'builds a form' do
        expect(subject.form).to be_a(form_class)
      end
    end

    context 'with an empty update' do
      let(:update) { nil }

      it 'is not valid' do
        expect(subject).to_not be_valid
        expect(subject.errors).to have_key(:update)
      end
    end

    context 'when the form class is missing' do
      let(:form_class) { nil }

      it 'is not valid' do
        expect(subject).to_not be_valid
        expect(subject.errors).to have_key(:form_class)
      end
    end

    context 'when the form class is not a subclass of BaseForm' do
      let(:form_class) { Object.new }

      it 'is not valid' do
        expect(subject).to_not be_valid
        expect(subject.errors).to have_key(:form_class)
      end
    end
  end

  describe '.run' do
    let(:attributes) {
      {
        'delivery_status' => 'red',
      }
    }

    subject do
      described_class.run(
        update: update,
        form_class: form_class,
        attributes: attributes
      )
    end

    context 'with valid attributes' do
      before(:each) do
        mock_form = mock(valid?: true, to_model_hash: attributes)

        form_class.expects(:from_form)
                  .with(attributes, model: update)
                  .returns(mock_form)
      end

      it 'is valid' do
        expect(subject).to be_valid
      end

      it 'persists the change' do
        expect { subject }.to change { update.reload.delivery_status }.to('red')
      end
    end

    context 'with invalid attributes' do
      before(:each) do
        mock_form = mock(valid?: false)

        form_class.expects(:from_form)
                  .with(attributes, model: update)
                  .returns(mock_form)
      end

      it 'is not valid' do
        expect(subject).to_not be_valid
        expect(subject.errors).to have_key(:form)
      end

      it 'does not amend the record' do
        expect { subject }.to_not change { update.reload.delivery_status }
      end
    end

    context 'with a missing form class' do
      let(:form_class) { nil }

      it 'is not valid' do
        expect(subject).to_not be_valid
        expect(subject.errors).to have_key(:form_class)
      end
    end

    context 'when the form class is not a subclass of BaseForm' do
      let(:form_class) { Object.new }

      it 'is not valid' do
        expect(subject).to_not be_valid
        expect(subject.errors).to have_key(:form_class)
      end
    end

    context 'with a missing update' do
      let(:update) { nil }

      it 'is not valid' do
        expect(subject).to_not be_valid
        expect(subject.errors).to have_key(:update)
      end
    end
  end

end
