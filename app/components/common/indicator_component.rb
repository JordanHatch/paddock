# frozen_string_literal: true

class Common::IndicatorComponent < BaseComponent
  option :label, optional: true

  renders_one :status, Common::StatusIndicatorComponent

  def class_name
    if label.present?
      'common__indicator-list__indicator'
    else
      'common__indicator-list__indicator common__indicator-list__indicator--no-label'
    end
  end
end
