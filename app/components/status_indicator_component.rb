# frozen_string_literal: true

class StatusIndicatorComponent < BaseComponent
  option :status
  option :label
  option :position, optional: true

  def status_class
    "status-indicator--#{status}" if status.present?
  end

  def position
    if super.present?
      super
    else
      :after
    end
  end

  def label
    if super.present?
      super
    else
      '&mdash;'.html_safe
    end
  end
end
