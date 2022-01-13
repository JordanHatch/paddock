class Manage::TeamForm < BaseForm
  attribute :name, Types::Nominal::String
  attribute :group_id, Types::Nominal::Integer
  attribute :start_on, Types::Nominal::Date
  attribute :end_on, Types::Nominal::Date

  validation do
    params do
      required(:name).filled(:string)
      required(:group_id).filled(:integer)
      optional(:end_on).maybe(:date)
      optional(:start_on).maybe(:date)
    end

    rule(:group_id) do
      key.failure('must exist') unless Group.exists?(value)
    end

    rule(:end_on, :start_on) do
      if values[:start_on].present? && values[:end_on].present? && (values[:end_on] < values[:start_on])
        key.failure('must be after the start date')
      end
    end
  end
end
