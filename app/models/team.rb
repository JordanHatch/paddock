class Team < ApplicationRecord
  extend FriendlyId

  belongs_to :group
  has_many :updates

  has_paper_trail skip: %i[created_at updated_at]

  friendly_id :name, use: :slugged

  scope :in_name_order, -> { order('name ASC') }
  scope :for_sprint, lambda { |sprint|
    where('(start_on IS NULL OR start_on <= ?) AND (end_on IS NULL OR end_on >= ?)', sprint.end_on, sprint.end_on)
  }

  def update_for_sprint(sprint)
    updates.find { |update| update.sprint_id == sprint.id } || updates.build
  end

  def active_in_sprint?(sprint)
    (start_on.blank? || start_on <= sprint.end_on) &&
      (end_on.blank? || end_on >= sprint.end_on)
  end
end
