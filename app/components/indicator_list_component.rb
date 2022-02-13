# frozen_string_literal: true

class IndicatorListComponent < BaseComponent
  STYLES = %i[inline inline_mini].freeze

  option :style, optional: true

  renders_many :indicators, IndicatorComponent

  def class_name
    if STYLES.include?(style)
      "indicator-list indicator-list--#{style.to_s.dasherize}"
    else
      'indicator-list'
    end
  end
end
