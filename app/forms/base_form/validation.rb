module BaseForm::Validation
  extend ActiveSupport::Concern

  class BaseContract < Dry::Validation::Contract
    config.messages.default_locale = :en
    config.messages.backend = :i18n
  end

  module ClassMethods
    attr_reader :schema_block

    def validation(&block)
      @schema_block = Class.new(BaseContract, &block)
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
      rows = send(key)

      nested_errors = rows.map do |row|
        row.validate

        row.errors
           .to_hash
           .with_indifferent_access
      end

      @errors[key] = nested_errors if nested_errors.reject(&:blank?).any?
    end
  end
end
