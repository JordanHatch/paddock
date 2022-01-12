class Quarters::Commitments::OverviewForm < BaseForm
  attribute :overview, Types::Nominal::String

  validation do
    params do
      required(:overview).filled(:string)
    end
  end
end
