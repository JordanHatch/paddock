class Quarters::Commitments::BenefitsForm < BaseForm
  attribute :benefits, Types::Nominal::Array

  preprocess do |form|
    (5 - form.benefits.size).times do
      form.benefits << ''
    end
  end

  before_validate do |_form, atts|
    atts[:benefits].reject!(&:blank?)
  end
end
