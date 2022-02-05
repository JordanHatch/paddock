class Quarters::Commitments::CreateForm < BaseForm
  attribute? :name, Types::Nominal::String
  attribute? :group_id, Types::Nominal::Integer

  def self.options
    Group.in_order
  end

  validation do
    params do
      required(:group_id).filled(:integer)
      required(:name).filled(:string)
    end

    rule(:group_id) do
      key.failure('must exist') if value.present? && !Quarters::Commitments::GroupForm.options.exists?(value)
    end
  end
end
