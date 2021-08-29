class SprintsController < ApplicationController
  layout 'updates'

  def index
    if Sprint.any?
      most_recent_sprint = Sprint.recent.first || Sprint.first
      redirect_to sprint_path(most_recent_sprint)
    end
  end

  def show; end

  def export
    debug = params.key?(:debug)
    pdf = PdfExporter.new(sprint_id: sprint.id, debug: debug).render

    if debug
      render inline: pdf
    else
      send_data pdf, filename: "#{sprint.name} - Sprint Report - #{Time.now.to_i}.pdf"
    end
  end

  def issues; end

  private

  helper_method :sprints, :sprint, :issues_search, :team_summaries, :delivery_status_summary

  def sprints
    @sprints ||= Sprint.in_date_order.all
  end

  def sprint
    @sprint ||= Sprint.find(params[:id]) if params.key?(:id)
  end

  def team_summaries
    @team_summaries ||= TeamSummary.for_sprint(sprint).with_groups
  end

  def issues_search
    @issues_search ||= Search::Issue.new(params:
      params.to_unsafe_h.symbolize_keys.merge(sprint_id: params[:id])
    )
  end

  def published_issues
    @published_issues ||= sprint.published_issues
  end

  def delivery_status_summary
    sprint.delivery_status_summary_counts
  end
end
