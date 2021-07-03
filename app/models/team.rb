class Team < ApplicationRecord
  extend FriendlyId

  belongs_to :group
  has_many :updates

  friendly_id :name, use: :slugged

  def update_for_sprint(sprint)
    updates.find {|update| update.sprint_id == sprint.id } || updates.build
  end
end
