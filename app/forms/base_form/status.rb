module BaseForm::Status
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

  def started?
    attributes.map { |_, value|
      value.is_a?(Array) ? value.reject(&:blank?) : value
    }.reject(&:blank?).any?
  end

  def validation_status
    valid? ? :valid : :invalid
  end
end
