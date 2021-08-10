class Team < ApplicationRecord
  extend FriendlyId

  belongs_to :group
  has_many :updates

  friendly_id :name, use: :slugged

  scope :for_sprint, ->(sprint) {
    where('start_on <= ?', sprint.end_on)
  }

  def update_for_sprint(sprint)
    updates.find {|update| update.sprint_id == sprint.id } || updates.build
  end
end
