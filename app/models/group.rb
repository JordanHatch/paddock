class Group < ApplicationRecord
  has_many :commitments
  has_many :teams, -> { in_name_order }
  has_many :updates, through: :teams

  scope :with_teams, -> { includes(:teams, :updates) }
  scope :in_order, -> { order('groups.order ASC') }

  def teams_for_sprint(sprint)
    teams.for_sprint(sprint)
  end
end
