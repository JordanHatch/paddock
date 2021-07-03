class ChangeHeadcountFieldsOnUpdates < ActiveRecord::Migration[6.1]
  def change
    add_column :updates, :vacant_roles, :integer
    remove_column :updates, :target_headcount, :integer
  end
end
