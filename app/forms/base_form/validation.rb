module BaseForm::Validation
  extend ActiveSupport::Concern

  module ClassMethods
    attr_reader :schema_block

    def validation(&block)
      @schema_block = Class.new(Dry::Validation::Contract, &block)
    end
  end

  def validate
    return true unless self.class.schema_block

    atts = to_hash.with_indifferent_access

    self.class.trigger_hook(:before_validate, self, atts)
    skip_validation_for_removed_nested_rows(self, atts)

    contract = self.class.schema_block.new
    @errors = contract.call(atts)
                .errors
                .to_hash
                .with_indifferent_access

    validate_nested_rows

    @errors.empty?
  end

  def valid?
    validate
  end

  private

  def validate_nested_rows
    self.class.nested_attributes.each do |key|
      key = self.class.nested_attributes_key(key).to_sym
      rows = self.send(key)

      nested_errors = rows.map {|row|
        row.validate

        row.errors
          .to_hash
          .with_indifferent_access
      }

      if nested_errors.reject(&:blank?).any?
        @errors[key] = nested_errors
      end
    end
  end
end
