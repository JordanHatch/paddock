class TeamHealthPresenter
  VALUES = Update.team_health.values
  extend ActionView::Helpers::TagHelper

  def self.all
    VALUES.map do |v|
      [format_label(v), v]
    end
  end

  def self.format_label(label)
    subtitle = I18n.t(:hint_text, scope: [:updates, :team_health, label], default: '')

    [
      content_tag(:div, label),
      (content_tag(:span, subtitle, class: 'radio-button__subtitle') if subtitle.present?),
    ].join.html_safe
  end
end
