require 'rails_helper'

RSpec.describe Quarters::UpdateCommitment do
  let(:commitment) { create(:commitment) }
  let(:form_class) { Quarters::Commitments::NameForm }
  let(:name) { 'A valid name' }
  let(:attributes) { { name: name } }

  let(:exception) { Quarters::UpdateCommitment::RequiredArgumentMissing }

  describe '.new' do
    subject do
      described_class.run(
        commitment: commitment,
        form_class: form_class,
      )
    end

    context 'with valid params' do
      it 'builds a form' do
        expect(subject.form).to be_a(form_class)
      end
    end

    context 'with an empty commitment' do
      let(:commitment) { nil }

      it 'raises an exception' do
        expect { subject.form }.to raise_error(exception)
      end
    end

    context 'when the form class is missing' do
      let(:form_class) { nil }

      it 'it raises an exception' do
        expect { subject }.to raise_error(exception)
      end
    end

    context 'when the form class is not a subclass of BaseForm' do
      let(:form_class) { Object.new }

      it 'is invalid' do
        expect { subject }.to raise_error(exception)
      end
    end
  end

  describe '.run' do
    subject do
      described_class.run(
        commitment: commitment,
        form_class: form_class,
        attributes: attributes,
      )
    end

    context 'with valid attributes' do
      it 'persists the change' do
        expect(subject).to be_valid

        commitment.reload
        expect(commitment.name).to eq(name)
      end
    end

    context 'when the form is invalid' do
      before(:each) do
        form_class.any_instance.stubs(:valid?).returns(false)
      end

      it 'is invalid' do
        expect(subject).to_not be_valid
        expect(subject.errors).to have_key(:form)
      end
    end

    context 'when the commitment is missing' do
      let(:commitment) { nil }

      it 'is raises an exception' do
        expect { subject }.to raise_error(exception)
      end
    end

    context 'when the form class is missing' do
      let(:form_class) { nil }

      it 'it raises an exception' do
        expect { subject }.to raise_error(exception)
      end
    end

    context 'when the form class is not a subclass of BaseForm' do
      let(:form_class) { Object.new }

      it 'is invalid' do
        expect { subject }.to raise_error(exception)
      end
    end
  end
end
