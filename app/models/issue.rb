class Issue < ApplicationRecord
  belongs_to :sprint_update, foreign_key: :update_id,
                             class_name: 'Update',
                             inverse_of: :issues
  has_one :team, through: :sprint_update
  has_one :sprint, through: :sprint_update

  has_paper_trail
end
