class Quarters::Commitments::CreateForm < BaseForm
  property :name
  property :group_id

  def self.options
    ::Group.in_order
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
