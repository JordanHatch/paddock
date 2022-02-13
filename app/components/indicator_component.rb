# frozen_string_literal: true

class IndicatorComponent < BaseComponent
  option :label, optional: true

  renders_one :status, StatusIndicatorComponent

  def class_name
    if label.present?
      'indicator-list__indicator'
    else
      'indicator-list__indicator indicator-list__indicator--no-label'
    end
  end
end
