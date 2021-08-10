class UpdatesController < ApplicationController
  layout 'updates'

  before_action :prevent_editing_when_published, only: [:edit, :update, :submit, :do_submit]

  def show; end
  def history; end

  def start
    if sprint_update.may_start?
      sprint_update.start!
    else
      flash.alert = 'This update can\'t be started'
    end

    redirect_to edit_update_path(sprint, team)
  end

  def edit
    @service = SprintUpdates::BuildUpdateService.(
      team_id: params[:team_id],
      sprint_id: params[:sprint_id],
      form_class: flow.form_class,
    )
  end

  def update
    @service = SprintUpdates::UpdateService.call(
      team_id: params[:team_id],
      sprint_id: params[:sprint_id],
      form_class: flow.form_class,
      attributes: params[:update],
    )

    if @service.success?
      if flow.last_form?
        redirect_to update_path(sprint, team)
      else
        redirect_to edit_update_form_path(sprint, team, flow.next_form_id)
      end
    else
      render :edit
    end
  end

  def submit
    @form_id = :submit

    @service = SprintUpdates::BuildPublishService.call(
      team_id: params[:team_id],
      sprint_id: params[:sprint_id],
      flow: flow,
    )
  end

  def do_submit
    @form_id = :submit

    @service = SprintUpdates::PublishService.call(
      team_id: params[:team_id],
      sprint_id: params[:sprint_id],
      flow: flow,
    )

    if @service.success?
      redirect_to update_path(sprint, team)
    else
      render action: :submit
    end
  end

  private

  attr_reader :service

  helper_method :flow, :service, :sprint, :team, :sprint_update

  def sprint
    @sprint ||= Sprint.find(params[:sprint_id])
  end

  def team
    @team ||= sprint.teams.friendly.find(params[:team_id])
  end

  def sprint_update
    @sprint_update ||= Update.find_or_initialize_by(sprint: sprint, team: team)
  end

  def flow
    @flow ||= SprintUpdates::UpdateFlow.new(
      current_form_id: @form_id || params[:form],
      sprint_update: sprint_update,
    )
  end

  def prevent_editing_when_published
    unless sprint_update.can_be_edited?
      flash.alert = 'This update has already been submitted and can no longer be updated.'
      redirect_to update_path(sprint, team)
    end
  end
end
