class Quarters::ReorderKeyCommitments < ActiveInteraction::Base
  record :quarter
  hash :order, strip: false

  validate :order_keys_and_values_are_numeric

  def execute
    order.transform_keys!(&:to_i)

    commitments = quarter.key_commitments.where(id: order.keys)

    return errors.add(:order) unless order.keys.sort == commitments.map(&:id).sort

    begin
      ActiveRecord::Base.transaction do
        commitments.each do |commitment|
          commitment.number = order[commitment.id]
          commitment.save!
        end
      end
    rescue ActiveRecord::RecordInvalid
      errors.add(:save)
    end
  end

  private

  def order_keys_and_values_are_numeric
    errors.add(:order) unless (order.keys + order.values).all? do |i|
                                i.is_a?(Integer) || (i.is_a?(String) && i.match?(/^\d+$/))
                              end
  end
end
