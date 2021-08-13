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

    atts = self.to_hash.with_indifferent_access

    self.class.trigger_hook(:before_validate, self, atts)
    skip_validation_for_removed_nested_rows(self, atts)

    contract = self.class.schema_block.new
    @errors = contract.call(atts).errors.to_hash

    @errors.empty?
  end

  def valid?
    self.validate
  end
end
