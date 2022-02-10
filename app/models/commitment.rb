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
  scope :in_key_and_alphabetical_order, -> { order('key_commitment DESC, number ASC, name ASC') }

  scope :for_quarter, ->(quarter) { where(quarter: quarter) }
  scope :for_commodity, lambda { |commodity|
    where('commitments.commodities @> ARRAY[?]', commodity) if commodity.present? && COMMODITIES.include?(commodity)
  }

  scope :grouped, lambda {
    scope = group_by(&:group_id)

    Group.in_order.to_h do |group|
      [group, scope.fetch(group.id, [])]
    end
  }

  scope :key_commitments, -> { where(key_commitment: true) }
  scope :other_commitments, -> { where(key_commitment: false) }
end
