class AddEndOnToTeams < ActiveRecord::Migration[6.1]
  def change
    add_column :teams, :end_on, :date
  end
end
