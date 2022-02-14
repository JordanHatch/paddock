# frozen_string_literal: true

class Common::StatusIndicatorComponent < BaseComponent
  option :status
  option :label
  option :position, optional: true

  def status_class
    "common__status-indicator--#{status}" if status.present?
  end

  def position
    if super.present?
      super.to_sym
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
