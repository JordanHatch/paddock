class Sprint < ApplicationRecord
  has_many :updates

  has_many :published_updates, -> { published }, class_name: 'Update'
  has_many :published_issues, -> { includes(:team) }, through: :published_updates, source: :issues

  has_paper_trail skip: %i[created_at updated_at]

  scope :in_date_order, -> { order('start_on asc') }
  scope :in_reverse_date_order, -> { order('start_on desc') }
  scope :recent, -> { where('start_on < ?', Date.today).order('start_on desc') }

  scope :for_quarter, ->(quarter) { where('end_on >= ? AND start_on <= ?', quarter.start_on, quarter.end_on) }

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

  def status
    if current?
      :current
    elsif historical?
      :historical
    elsif future?
      :future
    end
  end

  def current?
    Date.today >= start_on && Date.today <= end_on
  end

  def historical?
    Date.today > end_on
  end

  def future?
    Date.today < start_on
  end
end
