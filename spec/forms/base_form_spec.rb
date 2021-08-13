require 'rails_helper'

RSpec.describe BaseForm do

  class ExampleForm < BaseForm
    attribute? :name, Types::Nominal::String
    attribute? :lastname, Types::Nominal::String
    attribute? :array, Types::Nominal::Array.default([], shared: true)

    validation do
      required(:name).filled(:string)
    end
  end

  class ExampleNestedForm < BaseForm
    class Item < BaseForm
      attribute? :name, Types::Nominal::String
      attribute? :_destroy, Types::Nominal::Integer
    end

    nested_attributes :items

    attribute? :items_attributes, Types::Array.of(Item).default([], shared: true)

    validation do
      optional(:items_attributes).value(:array).each do
        schema do
          required(:name).filled(:string)
        end
      end
    end
  end

  def build_mock_model(attributes)
    OpenStruct.new(
      attributes.merge({
        attributes: attributes
      })
    )
  end

  let(:form_class) { ExampleForm }

  describe '#from_form' do
    context 'with parameters' do
      let(:params) {
        { name: 'Example' }
      }

      it 'parses the parameters into a form object' do
        form = form_class.from_form(params)
        expect(form.name).to eq('Example')
      end
    end

    context 'with strong parameters' do
      let(:params) {
        ActionController::Parameters.new({ name: 'Example' })
      }

      it 'parses the parameters into a form object' do
        form = form_class.from_form(params)
        expect(form.name).to eq('Example')
      end
    end

    context 'with nested parameters' do
      let(:form_class) { ExampleNestedForm }

      let(:params) {
        {
          'items_attributes' => {
            '1' => {
              'name' => 'Item 1',
            },
            '2' => {
              'name' => 'Item 2',
            }
          }
        }
      }

      it 'parses the nested parameters into an array' do
        form = form_class.from_form(params)

        expect(form.items_attributes).to contain_exactly(
          ExampleNestedForm::Item.new({ name: 'Item 1' }),
          ExampleNestedForm::Item.new({ name: 'Item 2' }),
        )
      end
    end
  end

  describe '#from_model' do
    context 'with a model' do
      let(:model) { build_mock_model(name: 'Example') }

      subject { form_class.from_model(model)  }

      it 'parses the model attributes into a form object' do
        expect(subject.name).to eq('Example')
      end
    end

    context 'with a model with nested children' do
      let(:form_class) { ExampleNestedForm }

      let(:model) {
        build_mock_model(
          items: [
            build_mock_model(name: 'Item 1'),
            build_mock_model(name: 'Item 2'),
          ],
        )
      }

      it 'parses the children into nested form objects' do
        form = form_class.from_model(model)

        expect(form.items_attributes).to contain_exactly(
          ExampleNestedForm::Item.new({ name: 'Item 1' }),
          ExampleNestedForm::Item.new({ name: 'Item 2' }),
        )
      end
    end
  end

  describe '#validate | #valid?' do
    context 'with valid attributes' do
      let(:params) { { name: 'Example' } }

      it 'returns true' do
        form = form_class.from_form(params)

        expect(form.validate).to be_truthy
        expect(form).to be_valid
      end
    end

    context 'with invalid attributes' do
      let(:params) { { name: '' } }

      it 'returns false' do
        form = form_class.from_form(params)

        expect(form.validate).to be_falsey
        expect(form).to_not be_valid
      end

      it 'assigns errors' do
        form = form_class.from_form(params)
        form.validate

        expect(form.errors).to contain_exactly(
          [ :name, ['must be filled'] ]
        )
      end
    end

    context 'with nested attributes' do
      let(:form_class) { ExampleNestedForm }

      it 'is true when valid' do
        params = {
          'items_attributes' => {
            '0' => {
              'name' => 'Example',
            },
          }
        }
        form = form_class.from_form(params)

        expect(form.validate).to be_truthy
        expect(form).to be_valid
      end

      it 'is false when invalid' do
        params = {
          'items_attributes' => {
            '0' => {
              'name' => '',
            },
          }
        }
        form = form_class.from_form(params)

        expect(form.validate).to be_falsey
        expect(form).to_not be_valid

        expect(form.errors).to eq({
          items_attributes: {
            0 => {
              name: ['must be filled'],
            }
          }
        })
      end

      it 'ignores objects with the "_destroy" key set' do
        params = {
          'items_attributes' => {
            '1' => {
              'name' => '',
              '_destroy' => 1,
            },
          }
        }
        form = form_class.from_form(params)

        expect(form.validate).to be_truthy
        expect(form).to be_valid
      end
    end
  end

  describe '#to_model_hash' do
    it 'returns an indifferent hash of all attributes' do
      params = { 'name' => 'Example' }
      form = form_class.from_form(params)
      hash = form.to_model_hash

      expect(hash['name']).to eq(params['name'])
      expect(hash[:name]).to eq(params['name'])
    end

    context 'with nested fields' do
      let(:form_class) { ExampleNestedForm }

      let(:params) {
        {
          'items_attributes' => {
            0 => {
              '_destroy' => nil,
              'name' => 'Item 1',
            },
            1 => {
              '_destroy' => nil,
              'name' => 'Item 2',
            },
          }
        }
      }

      it 'returns a hash of all nested fields' do
        form = form_class.from_form(params)
        hash = form.to_model_hash

        expect(hash).to eq(params)
      end
    end
  end

  describe '#started?' do
    context 'when all fields are empty' do
      let(:params) {
        { name: '' }
      }

      it 'is false' do
        form = form_class.from_form(params)

        expect(form).to_not be_started
      end
    end

    context 'when a field is present' do
      let(:params) {
        {
          name: '',
          lastname: 'Example',
        }
      }

      it 'is true' do
        form = form_class.from_form(params)

        expect(form).to be_started
      end
    end

    context 'with array fields' do
      context 'when an array is empty' do
        let(:params) {
          {
            name: '',
            lastname: '',
            array: [],
          }
        }

        it 'is false' do
          form = form_class.from_form(params)

          expect(form).to_not be_started
        end
      end

      context 'when an array has at least one value' do
        let(:params) {
          {
            name: '',
            lastname: '',
            array: ['item'],
          }
        }

        it 'is true' do
          form = form_class.from_form(params)

          expect(form).to be_started
        end
      end
    end
  end

  describe '#form_id' do
    it 'returns the form name with underscores' do
      expect(ExampleForm.new.form_id).to eq('example_form')
      expect(ExampleNestedForm.new.form_id).to eq('example_nested_form')
      expect(ExampleNestedForm::Item.new.form_id).to eq('item')
    end
  end

  describe '#template_name' do
    it 'returns the form name with underscores' do
      expect(ExampleForm.new.template_name).to eq('example_form')
      expect(ExampleNestedForm.new.template_name).to eq('example_nested_form')
      expect(ExampleNestedForm::Item.new.template_name).to eq('item')
    end
  end

end
