require 'rails_helper'

module ExampleForms
  class FormOne < BaseForm
    property :first_name

    validation do
      params do
        required(:first_name).filled(:string)
      end
    end
  end

  class FormTwo < BaseForm
    property :last_name

    validation do
      params do
        required(:last_name).filled(:string)
      end
    end
  end
end

class ExampleFlow < BaseFlow
  def forms
    {
      one: ExampleForms::FormOne,
      two: ExampleForms::FormTwo,
    }
  end

  private

  def default_form_id
    :one
  end
end

RSpec.describe BaseFlow do
  let(:object) { stub(first_name: 'Test', last_name: 'User') }
  let(:current_form_id) { :one }

  subject do
    ExampleFlow.new(current_form_id: current_form_id, object: object)
  end

  describe '#initialize' do
    it 'sets the current form id' do
      expect(subject.current_form_id).to eq(current_form_id)
    end

    context 'when current_form_id is a string' do
      let(:current_form_id) { 'one' }

      it 'converts the id to a symbol' do
        expect(subject.current_form_id).to eq(:one)
      end
    end

    it 'assigns the object' do
      expect(subject.send(:object)).to eq(object)
    end
  end

  describe '#form_keys' do
    it 'returns the keys of the forms hash' do
      expect(subject.form_keys).to contain_exactly(:one, :two)
    end
  end

  describe '#next_form_id' do
    context 'when the last form' do
      let(:current_form_id) { :two }

      it 'returns nil' do
        expect(subject.next_form_id).to be_nil
      end
    end

    context 'when not the last form' do
      let(:current_form_id) { :one }

      it 'returns the ID of the next form in the list' do
        expect(subject.next_form_id).to eq(:two)
      end
    end
  end

  describe '#last_form?' do
    context 'when the last form' do
      let(:current_form_id) { :two }

      it 'returns true' do
        expect(subject.last_form?).to be_truthy
      end
    end

    context 'when not the last form' do
      let(:current_form_id) { :one }

      it 'returns false' do
        expect(subject.last_form?).to be_falsey
      end
    end
  end

  describe '#form_class' do
    context 'when the ID exists' do
      it 'returns the form class' do
        expect(subject.form_class).to eq(ExampleForms::FormOne)
      end
    end

    context 'when the ID does not exist' do
      let(:current_form_id) { :foo }

      it 'raises a FormNotFound exception' do
        expect { subject.form_class }.to raise_error(BaseFlow::FormNotFound)
      end
    end
  end

  describe '#completion_status_for_form' do
    let(:mock_status) do
      { completion: :not_started }
    end

    it 'returns the status for the given form' do
      ExampleForms::FormOne.any_instance.stubs(:status).returns(mock_status)

      expect(subject.completion_status_for_form(:one)).to eq(:not_started)
    end
  end

  describe '#valid?' do
    context 'when all forms are valid' do
      let(:mock_status) do
        { validation: :valid }
      end

      before(:each) do
        ExampleForms::FormOne.any_instance.stubs(:status).returns(mock_status)
        ExampleForms::FormTwo.any_instance.stubs(:status).returns(mock_status)
      end

      it 'returns true' do
        expect(subject.valid?).to be_truthy
      end
    end

    context 'when one form is invalid' do
      before(:each) do
        ExampleForms::FormOne.any_instance.stubs(:status).returns({ validation: :valid })
        ExampleForms::FormTwo.any_instance.stubs(:status).returns({ validation: :invalid })
      end

      it 'returns true' do
        expect(subject.valid?).to be_falsey
      end
    end
  end
end
