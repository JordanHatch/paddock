class CreateQuarters < ActiveRecord::Migration[6.1]
  def change
    create_table :quarters do |t|
      t.string :name, null: false
      t.string :slug
      t.date :start_on, null: false
      t.date :end_on, null: false
      t.timestamps
    end
    add_index :quarters, :slug, unique: true
  end
end
