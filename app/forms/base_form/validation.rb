module BaseForm::Validation
  extend ActiveSupport::Concern

  module ClassMethods
    attr_reader :schema_block

    def validation(&block)
      @schema_block = Dry::Schema.Params(&block)
    end
  end

  def validate
    return true unless self.class.schema_block

    atts = self.to_hash.with_indifferent_access

    self.class.trigger_hook(:before_validate, self, atts)
    skip_validation_for_removed_nested_rows(self, atts)

    schema = self.class.schema_block.call(atts)
    @errors = schema.errors.to_hash

    schema.errors.empty?
  end

  def valid?
    self.validate
  end
end
