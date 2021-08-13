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

  private

  helper_method :sprints, :sprint, :groups, :delivery_status_summary

  def sprints
    @sprints ||= Sprint.in_date_order.all
  end

  def sprint
    if params.key?(:id)
      @sprint ||= Sprint.find(params[:id])
    end
  end

  def groups
    @groups ||= Group.in_order.with_teams
  end

  def delivery_status_summary
    sprint.delivery_status_summary_counts
  end

end
