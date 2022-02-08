class SprintUpdates::SummaryForm < BaseForm
  property :content

  validation do
    params do
      required(:content).filled(:string)
    end
  end
end
