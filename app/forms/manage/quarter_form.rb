class Manage::QuarterForm < BaseForm
  property :name
  property :start_on, multi_params: true
  property :end_on, multi_params: true
  property :editable

  validation do
    params do
      required(:name).filled(:string)
      required(:start_on).filled(:date)
      required(:end_on).filled(:date)
    end

    rule(:end_on, :start_on) do
      key.failure('must be after the start date') if values[:end_on] < values[:start_on]
    end
  end
end
