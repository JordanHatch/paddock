require 'rails_helper'

RSpec.describe Quarters::UpdateCommitment do
  let(:commitment) { create(:commitment) }
  let(:form_class) { Quarters::Commitments::NameForm }
  let(:name) { 'A valid name' }
  let(:attributes) { { name: name } }

  describe '.form' do
    subject do
      described_class.new(
        commitment: commitment,
        form_class: form_class,
      ).form
    end

    context 'with valid params' do
      it 'builds a form' do
        expect(subject).to be_a(form_class)
      end
    end
  end

  describe '.valid?' do
    subject do
      described_class.new(
        commitment: commitment,
        form_class: form_class,
      )
    end

    context 'with valid params' do
      it 'is valid' do
        expect(subject).to be_valid
      end
    end

    context 'with an empty commitment' do
      let(:commitment) { nil }

      it 'is not valid' do
        expect(subject).to_not be_valid
        expect(subject.errors).to have_key(:commitment)
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

    context 'when the quarter is not editable' do
      let(:commitment) do
        create(:commitment, quarter: create(:non_editable_quarter))
      end

      it 'is invalid' do
        expect(subject).to_not be_valid
        expect(subject.errors).to have_key(:commitment)
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

    context 'when the save fails' do
      before(:each) do
        commitment.expects(:save).returns(false)
      end

      it 'is not valid' do
        expect(subject).to_not be_valid
      end
    end
  end
end
