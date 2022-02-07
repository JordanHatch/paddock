class AddEditableToQuarters < ActiveRecord::Migration[7.0]
  def change
    add_column :quarters, :editable, :boolean, default: true, null: false
  end
end
