class ExportedSprintReport < ApplicationRecord
  belongs_to :sprint
  belongs_to :user

  has_one_attached :file
end
