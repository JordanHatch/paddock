# frozen_string_literal: true

class Common::IndicatorListComponent < BaseComponent
  STYLES = %i[inline inline_mini].freeze

  option :style, optional: true

  renders_many :indicators, Common::IndicatorComponent

  def class_name
    if STYLES.include?(style)
      "common__indicator-list common__indicator-list--#{style.to_s.dasherize}"
    else
      'common__indicator-list'
    end
  end
end
