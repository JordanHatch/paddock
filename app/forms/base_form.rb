class BaseForm < Dry::Struct
  extend Forwardable

  include BaseForm::Fields
  include BaseForm::Hooks
  include BaseForm::NestedAttributes
  include BaseForm::Status
  include BaseForm::Validation

  module Types
    include Dry.Types()
  end

  class << self
    def from_model(model)
      attributes = model.attributes

      deserialize_nested_attributes_from_model(self, attributes, model)

      trigger_hook(:deserialize_model, attributes, model)

      new(attributes).set_model(model)
    end

    def from_form(params, model: nil)
      attributes = if params.is_a?(ActionController::Parameters)
                     params.dup.permit!.to_hash
                   else
                     params.with_indifferent_access
                   end

      deserialize_nested_attributes_from_form(self, attributes)
      deserialize_date_fields_from_form(self, attributes)

      new(attributes).set_model(model)
    end
  end

  attr_reader :errors

  transform_keys(&:to_sym)

  # Delegate methods used by the form helpers to the underlying model
  #
  def_delegators :model, :model_name, :to_key, :to_param, :new_record?, :persisted?

  def initialize(*args)
    super(*args)
    @errors = {}

    define_stub_nested_attribute_writers(self)
    self.class.trigger_hook(:preprocess, self)
  end

  def set_model(model)
    tap { |f| f.send('model=', model) }
  end

  def to_model
    self
  end

  def to_model_hash
    attributes.with_indifferent_access.tap do |atts|
      self.class.trigger_hook(:before_validate, self, atts)
      serialize_nested_attributes_to_model_hash(self, atts)
    end
  end

  def form_id
    basename.underscore
  end

  def template_name
    basename.underscore
  end

  private

  attr_accessor :model

  def basename
    self.class.name.demodulize
  end
end
