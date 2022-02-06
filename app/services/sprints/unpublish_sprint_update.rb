class Sprints::UnpublishSprintUpdate < ActiveInteraction::Base
  record :update
  validate :update_can_be_unpublished?

  def execute
    errors.add(:save, 'failed') unless update.unpublish && update.save
  end

  private

  def update_can_be_unpublished?
    errors.add(:update, 'cannot be unpublished') unless update.may_unpublish?
  end
end
