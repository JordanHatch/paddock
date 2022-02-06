class Sprints::PublishSprintUpdate < ActiveInteraction::Base
  record :update
  object :flow, class: SprintUpdates::UpdateFlow

  validate :flow_complete?
  validate :update_can_be_published?

  def team
    update.team
  end

  def sprint
    update.sprint
  end

  def execute
    errors.add(:save, 'failed') unless update.publish && update.save
  end

  private

  def flow_complete?
    errors.add(:flow, 'is invalid') unless flow.valid?
  end

  def update_can_be_published?
    errors.add(:update, 'cannot be published') unless update.may_publish?
  end
end
