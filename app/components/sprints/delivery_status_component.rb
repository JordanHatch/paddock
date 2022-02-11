# frozen_string_literal: true

class Sprints::DeliveryStatusComponent < BaseComponent
  option :sprint

  private

  def statuses
    Update.delivery_status.values
  end

  def count(status)
    sprint.delivery_status_summary[status] || 0
  end

  def label(status)
    status.capitalize
  end
end
