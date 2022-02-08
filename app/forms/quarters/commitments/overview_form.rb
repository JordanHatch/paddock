class Quarters::Commitments::OverviewForm < BaseForm
  property :overview

  validation do
    params do
      required(:overview).filled(:string)
    end
  end
end
