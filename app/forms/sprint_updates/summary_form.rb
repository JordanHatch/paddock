class SprintUpdates::SummaryForm < BaseForm
  attribute :content, Types::Nominal::String

  validation do
    params do
      required(:content).filled(:string)
    end
  end
end
