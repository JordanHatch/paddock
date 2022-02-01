class Quarters::CommitmentFlow < BaseFlow
  def forms
    {
      name: Quarters::Commitments::NameForm,
      overview: Quarters::Commitments::OverviewForm,
      benefits: Quarters::Commitments::BenefitsForm,
      actions: Quarters::Commitments::ActionsForm,
      commodities: Quarters::Commitments::CommoditiesForm,
      group: Quarters::Commitments::GroupForm,
      teams: Quarters::Commitments::TeamsForm,
    }
  end

  private

  def default_form_id
    :name
  end
end
