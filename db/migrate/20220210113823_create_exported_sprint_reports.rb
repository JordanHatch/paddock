class CreateExportedSprintReports < ActiveRecord::Migration[7.0]
  def change
    create_table :exported_sprint_reports do |t|
      t.references :sprint, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
