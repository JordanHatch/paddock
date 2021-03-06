class Quarter < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  has_many :commitments
  has_many :key_commitments, -> { key_commitments }, class_name: 'Commitment'

  scope :in_reverse_date_order, -> { order('start_on DESC') }
  scope :previous_quarters, ->(quarter) { where('start_on < ?', quarter.start_on).order('start_on DESC') }
  scope :next_quarters, ->(quarter) { where('start_on > ?', quarter.start_on).order('start_on ASC') }

  class << self
    def current
      where('start_on <= ? AND end_on >= ?', Date.today, Date.today).first
    end
  end

  def current?
    start_on <= Date.today && end_on >= Date.today
  end

  def previous_quarter
    Quarter.previous_quarters(self).first
  end

  def next_quarter
    Quarter.next_quarters(self).first
  end
end
