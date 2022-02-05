require 'rails_helper'

RSpec.describe Quarters::CreateCommitment do

  let(:group) { create(:group) }
  let(:quarter) { create(:quarter) }
  let(:name) { 'Commitment name' }
  let(:group_id) { group.id }

  let(:form_class) { Quarters::Commitments::CreateForm }

  describe '.new' do
    subject { described_class.run(quarter: quarter) }

    context 'with valid params' do
      it 'builds a form' do
        expect(subject.form).to be_a(form_class)
      end
    end

    context 'with an empty quarter' do
      let(:quarter) { nil }

      it 'raises an exception' do
        expect{ subject.form }.to raise_error(Quarters::CreateCommitment::MissingQuarter)
      end
    end

    context 'with an invalid quarter' do
      let(:quarter) { nil }
    end
  end

  describe '.run' do
    subject do
      described_class.run(
        quarter: quarter,
        attributes: {
          name: name,
          group_id: group_id,
        },
      )
    end

    context 'with valid params' do
      it 'creates a commitment' do
        expect(subject).to be_valid

        record = Commitment.last
        expect(record.quarter).to eq(quarter)
        expect(record.name).to eq(name)
        expect(record.group).to eq(group)
      end
    end

    context 'with a valid quarter ID' do
      let(:quarter) { create(:quarter).id }

      it 'is valid' do
        expect(subject).to be_valid
      end
    end

    context 'with an empty quarter' do
      let(:quarter) { nil }

      it 'is invalid' do
        expect{ subject }.to raise_error(Quarters::CreateCommitment::MissingQuarter)
      end
    end

    context 'with an invalid quarter' do
      let(:quarter) { Object.new }

      it 'is invalid' do
        expect(subject).to_not be_valid
        expect(subject.errors).to have_key(:quarter)
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
  end
end
