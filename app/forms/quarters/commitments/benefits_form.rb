class Quarters::Commitments::BenefitsForm < BaseForm
  property :benefits

  def benefits=(value)
    super(value.reject!(&:blank?))
  end

  def prepopulate!
    (5 - benefits.size).times do
      benefits << ''
    end
  end
end
