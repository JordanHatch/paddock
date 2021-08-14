class Sprint < ApplicationRecord
  has_many :updates

  has_paper_trail skip: %i[created_at updated_at]

  scope :in_date_order, -> { order('start_on asc') }
  scope :in_reverse_date_order, -> { order('start_on desc') }
  scope :recent, -> { where('start_on < ?', Date.today).order('start_on desc') }

  scope :previous_sprints, ->(sprint) { where('start_on < ?', sprint.start_on).order('start_on DESC') }
  scope :next_sprints, ->(sprint) { where('start_on > ?', sprint.start_on).order('start_on ASC') }

  validates :name, :start_on, :end_on, presence: true

  def teams
    Team.for_sprint(self)
  end

  def previous_sprint
    Sprint.previous_sprints(self).first
  end

  def next_sprint
    Sprint.next_sprints(self).first
  end

  def delivery_status_summary
    updates.published.group(:delivery_status).count
  end
end
