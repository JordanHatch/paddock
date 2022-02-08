class Quarters::Commitments::NameForm < BaseForm
  property :name

  validation do
    params do
      required(:name).filled(:string)
    end
  end
end
