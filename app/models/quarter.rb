class Quarter < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  has_many :commitments
end
