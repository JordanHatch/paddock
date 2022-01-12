class Quarters::Commitments::NameForm < BaseForm
  attribute :name, Types::Nominal::String

  validation do
    params do
      required(:name).filled(:string)
    end
  end
end
