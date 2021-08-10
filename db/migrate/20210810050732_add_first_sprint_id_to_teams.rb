class AddFirstSprintIdToTeams < ActiveRecord::Migration[6.1]
  def change
    add_column :teams, :start_on, :date
  end
end
