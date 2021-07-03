class SprintUpdates::SummaryForm < BaseForm
  attribute :content, Types::Nominal::String

  validation do
    required(:content).filled(:string)
  end
end
