class CreateGroups < ActiveRecord::Migration[6.1]
  def change
    create_table :groups do |t|
      t.string :name, null: false
      t.timestamps
    end

    add_column :teams, :group_id, :integer
    add_foreign_key :teams, :groups, on_delete: :restrict
  end
end
