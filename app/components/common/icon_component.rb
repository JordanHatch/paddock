# frozen_string_literal: true

class Common::IconComponent < BaseComponent
  Sizes = Types::Coercible::Symbol.enum(:sm, :md, :lg, :xl)

  FONTAWESOME_ICONS = %w[
    chevron_down
    chevron_left
    chevron_right
    circle_exclamation
    close
    download
    invalid
    not_started
    star
    valid
    wrench
  ].freeze

  option :icon, type: proc(&:to_s)
  option :size, type: Sizes, optional: true, default: -> { :sm }

  def call
    content_tag :i, nil, class: classes
  end

  private

  def classes
    "icon icon--#{icon_type} icon--#{icon_class} icon--#{size}"
  end

  def icon_class
    icon.dasherize
  end

  def icon_type
    fontawesome_icon? ? 'fontawesome' : 'svg'
  end

  def fontawesome_icon?
    FONTAWESOME_ICONS.include?(icon)
  end
end
