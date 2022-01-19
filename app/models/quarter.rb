class Quarter < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  has_many :commitments

  scope :previous_quarters, ->(quarter) { where('start_on < ?', quarter.start_on).order('start_on DESC') }
  scope :next_quarters, ->(quarter) { where('start_on > ?', quarter.start_on).order('start_on ASC') }

  def previous_quarter
    Quarter.previous_quarters(self).first
  end

  def next_quarter
    Quarter.next_quarters(self).first
  end
end
