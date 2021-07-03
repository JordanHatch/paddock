class AddSprintToUpdates < ActiveRecord::Migration[6.1]
  def change
    add_column :updates, :sprint_id, :integer, null: false

    add_foreign_key :updates, :sprints, on_delete: :restrict
    add_index :updates, [:sprint_id, :team_id], unique: true
  end
end
