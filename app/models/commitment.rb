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
  ]

  enumerize :commodities, in: COMMODITIES, multiple: true

  belongs_to :quarter
end
