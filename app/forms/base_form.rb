class BaseForm < Dry::Struct
  module Types
    include Dry.Types()
  end

  class << self
    attr_reader :schema_block, :preprocess_block, :before_validate_block, :nested_attributes

    def validation(&block)
      @schema_block = Dry::Schema.Params(&block)
    end

    def preprocess(&block)
      @preprocess_block = block
    end

    def before_validate(&block)
      @before_validate_block = block
    end

    def nested_attributes(*atts)
      @nested_attributes ||= []
      @nested_attributes = @nested_attributes + atts
    end

    def from_model(model)
      attributes = model.attributes

      self.nested_attributes.each do |key|
        nested_key = nested_attributes_key(key)

        attributes[nested_key] = model.send(key).map {|model|
          model.attributes.merge(persisted: true)
        }
      end

      self.new(attributes)
    end

    def from_form(params)
      attributes = params.is_a?(ActionController::Parameters) ?
        params.dup.permit!.to_hash :
        params.with_indifferent_access

      # Convert nested fields from "<relation>_attributes" to an array of
      # hashes so that our form classes and validations can run properly.
      #
      self.nested_attributes.each do |key|
        nested_key = nested_attributes_key(key)
        nested_atts = attributes[nested_key]

        new_array = []
        nested_atts.to_hash.map do |id, atts|
          new_array << atts
        end

        attributes[nested_key] = new_array
      end

      self.new(attributes)
    end

    def nested_attributes_key(key)
      "#{key}_attributes"
    end
  end

  attr_reader :errors

  transform_keys(&:to_sym)

  def initialize(*args)
    super(*args)
    @errors = {}

    self.class.nested_attributes.each do |key|
      self.class.define_method("#{key}_attributes=") {}
    end

    self.class.preprocess_block.call(self) if self.class.preprocess_block
  end

  def validate
    return true unless self.class.schema_block

    atts = self.to_hash.with_indifferent_access

    self.class.before_validate_block.call(atts) if self.class.before_validate_block

    # Don't try and validate nested rows which are already earmarked for
    # removal.
    #
    self.class.nested_attributes.each do |key|
      nested_key = self.class.nested_attributes_key(key)
      if atts.key?(nested_key)
        atts[nested_key].reject! {|o| o[:_destroy].present? }
      end
    end

    schema = self.class.schema_block.call(atts)
    @errors = schema.errors.to_hash

    schema.errors.empty?
  end

  def to_model_hash
    atts = self.attributes.with_indifferent_access

    self.class.before_validate_block.call(atts) if self.class.before_validate_block

    # Rewrite nested attributes to the "<relation>_attributes" format
    # so that ActiveRecord can persist the changes properly.
    #
    self.class.nested_attributes.each do |key|
      nested_key = self.class.nested_attributes_key(key)

      if atts.key?(nested_key)
        nested_atts = Hash[
          atts[nested_key].map.with_index {|form, i|
            [ i, form.to_hash ]
          }
        ]

        atts[nested_key] = nested_atts
      end
    end

    atts
  end

  def started?
    self.attributes.map {|_, value|
      value.is_a?(Array) ? value.reject(&:blank?) : value
    }.reject(&:blank?).any?
  end

  def valid?
    self.validate
  end

  def status
    {
      completion: completion_status,
      validation: validation_status,
    }
  end

  def completion_status
    return :not_started unless started?
    return :valid if valid?
    :invalid
  end

  def validation_status
    valid? ? :valid : :invalid
  end

  def form_id
    basename.underscore
  end

  def template_name
    basename.underscore
  end

  private

  def basename
    self.class.name.demodulize
  end
end
