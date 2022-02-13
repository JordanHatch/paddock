# frozen_string_literal: true

class Sprints::UpdatePreviewComponent < BaseComponent
  option :team_summary

  with_collection_parameter :team_summary

  def render?
    team_summary.present? &&
      team_summary.team.present? &&
      team_summary.sprint.present?
  end
end
