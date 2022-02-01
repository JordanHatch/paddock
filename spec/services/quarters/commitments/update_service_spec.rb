require 'rails_helper'

RSpec.describe Quarters::Commitments::UpdateService do
  let(:commitment) { create(:commitment) }
  let(:commitment_id) { commitment.id }
  let(:form_class) { Quarters::Commitments::NameForm }

  describe '.call' do
    subject do
      described_class.call(
        commitment_id: commitment_id,
        form_class: form_class,
        attributes: attributes,
      )
    end

    context 'with valid attributes' do
      let(:attributes) do
        { name: 'A valid name' }
      end

      it 'is successful' do
        expect(subject).to be_success
      end

      it 'persists the change' do
        subject.commitment.reload
        expect(subject.commitment.name).to eq(attributes[:name])
      end
    end

    context 'with invalid attributes' do
      let(:attributes) do
        { name: nil }
      end

      it 'is not successful' do
        expect(subject).to_not be_success
        expect(subject).to be_failure
      end

      it 'does not persist the change' do
        subject.commitment.reload
        expect(subject.commitment.name).to eq(commitment.name)
      end

      it 'returns a form object with errors' do
        expect(subject.form.errors).to eq({ 'name' => ['must be filled'] })
      end
    end
  end
end
