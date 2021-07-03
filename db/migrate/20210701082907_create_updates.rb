class CreateUpdates < ActiveRecord::Migration[6.1]
  def change
    create_table :updates do |t|
      t.text :content
      t.references :team, null: false, foreign_key: true

      t.timestamps
    end
  end
end
