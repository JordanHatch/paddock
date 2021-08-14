module BaseForm::NestedAttributes
  extend ActiveSupport::Concern

  class_methods do
    attr_reader :nested_attributes

    def nested_attributes(*atts)
      @nested_attributes ||= []
      @nested_attributes += atts
    end

    def nested_attributes_key(key)
      "#{key}_attributes"
    end

    def deserialize_nested_attributes_from_model(form, attributes, model)
      form.nested_attributes.each do |key|
        nested_key = nested_attributes_key(key)

        attributes[nested_key] = model.send(key).map do |nested_model|
          nested_model.attributes.merge(persisted: true)
        end
      end
    end

    # Convert nested fields from "<relation>_attributes" to an array of
    # hashes so that our form classes and validations can run properly.
    #
    def deserialize_nested_attributes_from_form(form, attributes)
      form.nested_attributes.each do |key|
        nested_key = nested_attributes_key(key)
        nested_atts = attributes[nested_key]

        new_array = []
        nested_atts.to_hash.map do |_id, atts|
          new_array << atts
        end

        attributes[nested_key] = new_array
      end
    end
  end

  def define_stub_nested_attribute_writers(form)
    form.class.nested_attributes.each do |key|
      # rubocop:disable Lint/EmptyBlock
      form.class.define_method("#{key}_attributes=") {}
      # rubocop:enable Lint/EmptyBlock
    end
  end

  # Rewrite nested attributes to the "<relation>_attributes" format
  # so that ActiveRecord can persist the changes properly.
  #
  def serialize_nested_attributes_to_model_hash(form, attributes)
    form.class.nested_attributes.each do |key|
      nested_key = form.class.nested_attributes_key(key)

      next unless attributes.key?(nested_key)

      nested_atts = attributes[nested_key].map.with_index { |nested_form, i|
        [i, nested_form.to_hash]
      }.to_h

      attributes[nested_key] = nested_atts
    end
  end

  # Don't try and validate nested rows which are already earmarked for
  # removal.
  #
  def skip_validation_for_removed_nested_rows(form, attributes)
    form.class.nested_attributes.each do |key|
      nested_key = form.class.nested_attributes_key(key)
      attributes[nested_key].reject! { |o| o[:_destroy].present? } if attributes.key?(nested_key)
    end
  end
end
