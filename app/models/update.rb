class Update < ApplicationRecord
  extend Enumerize
  include AASM

  belongs_to :team
  belongs_to :sprint
  has_one :group, through: :team

  has_many :issues, inverse_of: :sprint_update
  has_paper_trail skip: %i[created_at updated_at]

  accepts_nested_attributes_for :issues, allow_destroy: true, reject_if: :all_blank

  enumerize :delivery_status, in: %i[green amber red]
  enumerize :okr_status, in: %i[green amber red]
  enumerize :team_health, in: [1, 2, 3, 4, 5]

  scope :recent_first, -> { order('created_at DESC') }
  scope :published_for_sprint, ->(sprint) { where(sprint: sprint).published }
  scope :by_sprint_id, ->(id) { where(sprint_id: id ) }

  aasm(column: :state) do
    state :not_started, initial: true
    state :draft
    state :published

    event :start do
      transitions from: :not_started, to: :draft
    end

    event :publish do
      transitions from: :draft, to: :published
    end

    event :unpublish do
      transitions from: :published, to: :draft
    end
  end

  def can_be_edited?
    draft?
  end

  def total_headcount
    (current_headcount || 0) + (vacant_roles || 0)
  end

  def recent_versions
    versions.order('created_at DESC')
  end
end
