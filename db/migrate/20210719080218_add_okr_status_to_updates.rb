class AddOkrStatusToUpdates < ActiveRecord::Migration[6.1]
  def change
    add_column :updates, :okr_status, :string
  end
end
