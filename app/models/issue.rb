class Issue < ApplicationRecord
  belongs_to :sprint_update, foreign_key: :update_id,
                             class_name: 'Update',
                             inverse_of: :issues
  has_one :team, through: :sprint_update
  has_one :sprint, through: :sprint_update

  has_paper_trail

  scope :with_identifier, -> { where("identifier <> ''") }

  scope :without_identifier, -> { where("identifier IS NULL or identifier = ''") }

  scope :for_group_ids, lambda { |group_ids|
    joins(:sprint_update).joins(:team)
                         .where('teams.group_id = ANY(ARRAY[?]::int[])', group_ids)
  }

  scope :for_sprint_id, lambda { |sprint_id|
    joins(:sprint_update)
      .where('updates.sprint_id': sprint_id)
  }

  scope :published, lambda {
    joins(:sprint_update)
      .where('updates.state': 'published')
  }
end
