class AddFieldsToUpdates < ActiveRecord::Migration[6.1]
  def change
    add_column :updates, :delivery_status, :string

    add_column :updates, :team_health, :string

    add_column :updates, :current_headcount, :integer
    add_column :updates, :target_headcount, :integer

    add_column :updates, :sprint_goals, :text, array: true, default: []
    add_column :updates, :next_sprint_goals, :text, array: true, default: []
  end
end
