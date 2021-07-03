class Group < ApplicationRecord
  has_many :teams
  has_many :updates, through: :teams

  scope :with_teams, ->{ includes(:teams, :updates) }
end
