class Manage::TeamForm < BaseForm
  attribute :name, Types::Nominal::String
  attribute :group_id, Types::Nominal::Integer
  attribute :start_on, Types::Nominal::Date

  validation do
    params do
      required(:name).filled(:string)
      required(:group_id).filled(:integer)
    end

    rule(:group_id) do
      key.failure('must exist') unless Group.exists?(value)
    end
  end
end
