class Quarters::Commitments::ReorderService < BaseService
  def initialize(quarter_id:, order: {})
    @quarter_id = quarter_id
    @order = order
  end

  def call
    yield validate_object
    yield validate_parameters
    yield convert_form_parameters
    yield find_commitments
    yield update_commitments

    Success(quarter)
  end

  def quarter
    @quarter ||= Quarter.find(quarter_id)
  end

  private

  attr_reader :quarter_id, :order, :commitments

  def validate_object
    if quarter.present?
      Success(quarter)
    else
      Failure(:invalid_quarter)
    end
  end

  def validate_parameters
    if order.is_a?(Hash) &&
        (order.keys + order.values).all? do |i|
          i.is_a?(Integer) || (i.is_a?(String) && i.match?(/^\d+$/))
        end
      Success(order)
    else
      Failure(:invalid_parameters)
    end
  end

  def convert_form_parameters
    @order = order.transform_keys(&:to_i)
                  .transform_values(&:to_i)

    Success(order)
  end

  def find_commitments
    @commitments = order.keys.map do |id|
      quarter.commitments.find(id)
    end

    Success(@commitments)
  rescue ActiveRecord::RecordNotFound
    Failure(:invalid_commitment)
  end

  def update_commitments
    commitments.each do |commitment|
      commitment.number = order[commitment.id]

      return Failure(:save_failed) unless commitment.save
    end

    Success(quarter.commitments)
  rescue ActiveRecord::StatementInvalid
    Failure(:save_failed)
  end
end
