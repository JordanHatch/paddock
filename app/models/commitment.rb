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

  scope :in_order, -> { order('number ASC') }
end
