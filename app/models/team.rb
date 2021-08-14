class Team < ApplicationRecord
  extend FriendlyId

  belongs_to :group
  has_many :updates

  has_paper_trail skip: %i[created_at updated_at]

  friendly_id :name, use: :slugged

  scope :for_sprint, lambda { |sprint|
    where('start_on IS NULL OR start_on <= ?', sprint.end_on)
  }

  def update_for_sprint(sprint)
    updates.find { |update| update.sprint_id == sprint.id } || updates.build
  end

  def active_in_sprint?(sprint)
    start_on.blank? ||
      start_on <= sprint.end_on
  end
end
