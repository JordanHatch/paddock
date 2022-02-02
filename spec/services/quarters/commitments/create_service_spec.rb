require 'rails_helper'

RSpec.describe Quarters::Commitments::CreateService do
  let(:quarter) { create(:quarter) }
  let(:group) { create(:group) }

  describe '.build' do
    let(:group_id) { group.id }

    subject { described_class.build(quarter_id: quarter_id, group_id: group_id) }

    context 'with a valid quarter' do
      let(:quarter_id) { quarter.id }

      it 'is successful' do
        expect(subject).to be_success
      end

      it 'builds a form' do
        expect(subject.form).to be_a(Quarters::Commitments::CreateForm)
      end

      it 'sets the group_id attribute on the form' do
        expect(subject.form.group_id).to eq(group_id)
      end

      it 'assigns a commitment object' do
        expect(subject.commitment).to be_a(Commitment)
      end
    end

    context 'with an invalid quarter' do
      let(:quarter_id) { 123456 }

      it 'is not successful' do
        expect(subject).to_not be_success
      end
    end

    context 'with a blank quarter' do
      let(:quarter_id) { nil }

      it 'is not successful' do
        expect(subject).to_not be_success
      end
    end
  end

  describe '.call' do
    subject { described_class.call(quarter_id: quarter_id, attributes: attributes) }

    let(:quarter_id) { quarter.id }
    let(:name) { 'Name' }
    let(:group_id) { group.id }

    let(:attributes) do
      {
        name: name,
        group_id: group_id,
      }
    end

    context 'with valid parameters' do
      it 'is successful' do
        expect(subject).to be_success
      end

      it 'saves the commitment' do
        expect(subject.commitment).to be_persisted
      end

      it 'sets the name and group' do
        expect(subject.commitment.name).to eq(name)
        expect(subject.commitment.group).to eq(group)
      end
    end

    context 'with an empty quarter' do
      let(:quarter_id) { nil }

      it 'is not successful' do
        expect(subject).to_not be_success
        expect(subject.result.failure).to eq(:invalid_quarter)
      end
    end

    context 'with an invalid quarter' do
      let(:quarter_id) { 123456 }

      it 'is not successful' do
        expect(subject).to_not be_success
        expect(subject.result.failure).to eq(:invalid_quarter)
      end
    end

    context 'with an empty name' do
      let(:name) { nil }

      it 'is not successful' do
        expect(subject).to_not be_success
        expect(subject.form.errors).to have_key('name')
      end
    end

    context 'with an empty group_id' do
      let(:group_id) { nil }

      it 'is not successful' do
        expect(subject).to_not be_success
        expect(subject.form.errors).to have_key('group_id')
      end
    end

    context 'with an invalid group_id' do
      let(:group_id) { 123456 }

      it 'is not successful' do
        expect(subject).to_not be_success
        expect(subject.form.errors).to have_key('group_id')
      end
    end
  end
end
