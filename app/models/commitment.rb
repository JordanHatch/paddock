class Commitment < ApplicationRecord
  extend Enumerize

  COMMODITIES = %w[
    meat
    eggs
    fish
    dairy
    horticulture
    grain
    honey
    lae
  ].freeze

  enumerize :commodities, in: COMMODITIES, multiple: true

  belongs_to :quarter
  belongs_to :group

  has_many :team_commitments
  has_many :teams, through: :team_commitments

  has_paper_trail skip: %i[created_at updated_at]

  scope :in_order, -> { order('number ASC') }

  scope :key_commitments, -> { where(key_commitment: true) }
  scope :other_commitments, -> { where(key_commitment: false) }
end
