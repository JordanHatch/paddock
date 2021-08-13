require 'rails_helper'

RSpec.describe SprintUpdates::UpdateFlow do

  let(:sprint_update) { create(:draft_sprint_update) }

  let(:forms) {
    SprintUpdates::UpdateFlow::FORMS
  }

  describe '#initialize' do
    context 'when the current_form_id is nil' do
      it 'returns the default (delivery_status) form' do
        flow = described_class.new(
          current_form_id: nil,
          sprint_update: sprint_update,
        )
        expect(flow.current_form_id).to eq(:delivery_status)
      end
    end
  end

  describe '#form_class' do
    it 'returns the form class for the provided form id' do
      # Pick a form at random
      form_id = forms.keys.sample
      expected_class = forms[form_id]

      flow = described_class.new(
        current_form_id: form_id,
        sprint_update: sprint_update,
      )
      expect(flow.form_class).to eq(expected_class)
    end
  end

  describe '#next_form_id' do
    it 'returns the next form for the given form id' do
      form_id = forms.keys[1]
      next_form_id = forms.keys[2]

      flow = described_class.new(
        current_form_id: form_id,
        sprint_update: sprint_update,
      )
      expect(flow.next_form_id).to eq(next_form_id)
    end

    it 'nil when the current form is the last' do
      form_id = forms.keys[-1]

      flow = described_class.new(
        current_form_id: form_id,
        sprint_update: sprint_update,
      )
      expect(flow.next_form_id).to be_nil
    end
  end

  describe '#last_form?' do
    context 'when the current form is the last' do
      it 'returns true' do
        form_id = forms.keys[-1]

        flow = described_class.new(
          current_form_id: form_id,
          sprint_update: sprint_update,
        )
        expect(flow).to be_last_form
      end
    end

    context 'when the current form is not the last' do
      it 'returns false' do
        form_id = forms.keys[0]

        flow = described_class.new(
          current_form_id: form_id,
          sprint_update: sprint_update,
        )
        expect(flow).to_not be_last_form
      end
    end
  end

  describe '#valid?' do
    context 'when all forms are valid' do
      before(:each) do
        forms.values.each do |form_class|
          mock_form = stub(status: { validation: :valid },)
          form_class.expects(:from_model).returns(mock_form)
        end
      end

      it 'returns true' do
        flow = described_class.new(
          current_form_id: forms.keys.first,
          sprint_update: sprint_update,
        )

        expect(flow).to be_valid
      end
    end

    context 'when one form is invalid' do
      before(:each) do
        invalid_form = stub(status: { validation: :invalid })
        forms.values[0].expects(:from_model).returns(invalid_form)

        forms.values[1..-1].each do |form_class|
          mock_form = stub(status: { validation: :valid })
          form_class.expects(:from_model).returns(mock_form)
        end
      end

      it 'returns false' do
        flow = described_class.new(
          current_form_id: forms.keys.first,
          sprint_update: sprint_update,
        )

        expect(flow).to_not be_valid
      end
    end

    context 'when one form is not_started' do
      before(:each) do
        not_started_form = stub(status: { validation: :not_started })
        forms.values[0].expects(:from_model).returns(not_started_form)

        forms.values[1..-1].each do |form_class|
          mock_form = stub(status: { validation: :valid })
          form_class.expects(:from_model).returns(mock_form)
        end
      end

      it 'returns false' do
        flow = described_class.new(
          current_form_id: forms.keys.first,
          sprint_update: sprint_update,
        )

        expect(flow).to_not be_valid
      end
    end
  end

  describe '#completion_status_for_form' do
    it 'returns the value of the `completion` status attribute for the given form' do
      form_id = forms.keys.first

      mock_form = stub(status: { completion: :valid })
      forms[form_id].expects(:from_model).returns(mock_form)

      flow = described_class.new(
        current_form_id: forms.keys.first,
        sprint_update: sprint_update,
      )

      expect(flow.completion_status_for_form(form_id)).to eq(:valid)
    end
  end

end
