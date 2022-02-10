class Quarters::Commitments::BenefitsForm < BaseForm
  property :benefits

  def benefits=(value)
    value = [] unless value.is_a?(Array)
    super(value.reject(&:blank?))
  end

  def prepopulate!
    self.benefits = [] unless benefits.is_a?(Array)

    (5 - benefits.size).times do
      benefits << ''
    end
  end
end
