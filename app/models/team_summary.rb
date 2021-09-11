class TeamSummary < ApplicationRecord
  extend Forwardable

  belongs_to :team, foreign_key: 'id'
  belongs_to :sprint_update, foreign_key: 'update_id', class_name: 'Update'

  scope :for_sprint, lambda { |sprint|
    where(sprint_id: sprint.id)
      .includes(:sprint_update)
      .order('name ASC')
  }
  scope :with_groups, lambda {
    all_groups = Group.in_order.map do |group|
      [
        group,
        self.select { |t| t.group_id == group.id },
      ]
    end

    all_groups.reject do |(_group, teams)|
      teams.empty?
    end
  }

  def_delegators :sprint_update, :delivery_status_text, :okr_status_text

  def published?
    sprint_update.present? && sprint_update.published?
  end

  def to_param
    slug
  end

  # Disables the default ActiveRecord save behaviour
  #
  def readonly?
    true
  end
end
