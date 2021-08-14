class TeamHealthPresenter
  VALUES = Update.team_health.values
  extend ActionView::Helpers::TagHelper

  def self.all
    VALUES.map do |v|
      [format_label(v), v]
    end
  end

  def self.format_label(label)
    [
      label,
      content_tag(
        :span,
        I18n.t(:hint_text, scope: [:updates, :team_health, label], default: ''),
      ),
    ].join.html_safe
  end
end
