class AddStateToUpdate < ActiveRecord::Migration[6.1]
  def change
    add_column :updates, :state, :string, default: 'not_started'
  end
end
