class UpdatesController < ApplicationController
  layout 'updates'

  before_action :prevent_editing_when_published, only: %i[edit update submit do_submit]

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
    @service = Sprints::UpdateSprintUpdate.new(
      update: sprint_update,
      form_class: flow.form_class,
    )

    @service.form.prepopulate!
    @service.form.validate({}) if @service.form.started?
  end

  def update
    @service = Sprints::UpdateSprintUpdate.run(
      update: sprint_update,
      form_class: flow.form_class,
      attributes: params[:update].permit!,
    )

    if @service.valid?
      if flow.last_form?
        redirect_to update_path(sprint, team)
      else
        redirect_to edit_update_form_path(sprint, team, flow.next_form_id)
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def submit
    @form_id = :submit

    @service = Sprints::PublishSprintUpdate.new(
      update: sprint_update,
      flow: flow,
    )
  end

  def do_submit
    @form_id = :submit

    @service = Sprints::PublishSprintUpdate.run(
      update: sprint_update,
      flow: flow,
    )

    if @service.valid?
      redirect_to update_path(sprint, team)
    else
      render action: :submit, status: :unprocessable_entity
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
      object: sprint_update,
    )
  end

  def prevent_editing_when_published
    unless sprint_update.can_be_edited?
      flash.alert = 'This update has already been submitted and can no longer be updated.'
      redirect_to update_path(sprint, team)
    end
  end
end
