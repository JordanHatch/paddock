require 'rails_helper'

class ExampleForm < BaseForm
  property :name
  property :lastname
  property :array

  validation do
    params do
      required(:name).filled(:string)
    end
  end
end

RSpec.describe BaseForm do
  def build_mock_model(attributes)
    stub(
      attributes.merge({
        attributes: attributes,
      }),
    )
  end

  let(:form_class) { ExampleForm }
  let(:model) { OpenStruct.new }

  describe '#started?' do
    subject do
      form_class.new(model).tap {|form| form.validate(params) }
    end

    context 'when all fields are empty' do
      let(:params) do
        { name: '' }
      end

      it 'is false' do
        expect(subject).to_not be_started
      end
    end

    context 'when a field is present' do
      let(:params) do
        {
          name: '',
          lastname: 'Example',
        }
      end

      it 'is true' do
        expect(subject).to be_started
      end
    end

    context 'with array fields' do
      context 'when an array is empty' do
        let(:params) do
          {
            name: '',
            lastname: '',
            array: [],
          }
        end

        it 'is false' do
          expect(subject).to_not be_started
        end
      end

      context 'when an array has at least one value' do
        let(:params) do
          {
            name: '',
            lastname: '',
            array: %w[item],
          }
        end

        it 'is true' do
          expect(subject).to be_started
        end
      end
    end
  end

  describe '#form_id' do
    it 'returns the form name with underscores' do
      expect(ExampleForm.new(model).form_id).to eq('example_form')
    end
  end

  describe '#template_name' do
    it 'returns the form name with underscores' do
      expect(ExampleForm.new(model).template_name).to eq('example_form')
    end
  end
end
