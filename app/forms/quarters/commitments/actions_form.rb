class Quarters::Commitments::ActionsForm < BaseForm
  attribute :actions, Types::Nominal::Array

  preprocess do |form|
    (5 - form.actions.size).times do
      form.actions << ''
    end
  end

  before_validate do |_form, atts|
    atts[:actions].reject!(&:blank?)
  end
end
